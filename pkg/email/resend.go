package email

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
)

type Client struct {
	apiKey string
	from   string
}

func New(apiKey, from string) *Client {
	return &Client{apiKey: apiKey, from: from}
}

type sendRequest struct {
	From    string `json:"from"`
	To      string `json:"to"`
	Subject string `json:"subject"`
	HTML    string `json:"html"`
}

func (c *Client) send(to, subject, html string) error {
	body, _ := json.Marshal(sendRequest{
		From:    c.from,
		To:      to,
		Subject: subject,
		HTML:    html,
	})

	req, err := http.NewRequest("POST", "https://api.resend.com/emails", bytes.NewBuffer(body))
	if err != nil {
		return err
	}
	req.Header.Set("Authorization", "Bearer "+c.apiKey)
	req.Header.Set("Content-Type", "application/json")

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return fmt.Errorf("resend request: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode >= 400 {
		return fmt.Errorf("resend error: status %d", resp.StatusCode)
	}
	return nil
}

func (c *Client) SendWelcome(to, name string) error {
	html := fmt.Sprintf(`
		<h1>Welcome to NetBreaker, %s!</h1>
		<p>You now have access to 3 free labs. Build networks, then hack them.</p>
		<p><a href="https://netbreaker.io/labs">Start your first lab →</a></p>
	`, name)
	return c.send(to, "Welcome to NetBreaker", html)
}

func (c *Client) SendProUpgrade(to, name string) error {
	html := fmt.Sprintf(`
		<h1>You are now a NetBreaker Pro, %s!</h1>
		<p>All 14 labs are now unlocked — including full attack walkthroughs and GNS3 config downloads.</p>
		<p><a href="https://netbreaker.io/labs">Start the next lab →</a></p>
	`, name)
	return c.send(to, "NetBreaker Pro — all labs unlocked", html)
}

func (c *Client) SendCertificate(to, name, verifyCode string) error {
	html := fmt.Sprintf(`
		<h1>Congratulations, %s!</h1>
		<p>You have completed all 14 NetBreaker labs. Your certificate is ready.</p>
		<p>Certificate code: <strong>%s</strong></p>
		<p><a href="https://netbreaker.io/certificate/verify/%s">View your certificate →</a></p>
	`, name, verifyCode, verifyCode)
	return c.send(to, "Your NetBreaker Certificate is Ready", html)
}

func (c *Client) SendTeamInvite(to, teamName, inviteURL string) error {
	html := fmt.Sprintf(`
		<h1>You have been invited to join %s on NetBreaker</h1>
		<p><a href="%s">Accept invitation →</a></p>
	`, teamName, inviteURL)
	return c.send(to, "NetBreaker Team Invitation", html)
}

نحتاج نضيف:

1. إضافة `KALI_PINNED_TAG` لـ `.env` على VPS
2. إضافة `KaliPinnedTag` لـ `Config` struct
3. إضافة `ensureKaliImage` method — يستعمل GNS3 `/v2/computes/{id}/docker/images`
4. Log WARN لما default يطبق
5. Pre-flight check قبل node creation
6. Fail-closed مع "run build.sh" message

نبدأ بالـ config:
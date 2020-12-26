# BitWarden_RS Dropbox Nightly Backup
Run this image alongside your bitwarden_rs container for automated nightly (1AM UTC) backups of your BitWarden database to your Dropbox account. Backups are encrypted (OpenSSL AES256) and zipped (`.tar.gz`) with a passphrase of your choice.

**IMPORTANT: Make sure you have at least one personal device (e.g. laptop) connected to Dropbox and syncing files locally. This will save you in the event Bitwarden goes down and your Dropbox account login was stored in Bitwarden!!!**

**Note:** Encrypting BitWarden backups is not required since the data is already encrypted with user master passwords. We've added this for good practice and added obfuscation should your Dropbox account get compromised.

## How to Use
- It's highly recommend you run via the `docker-compose.yml` provided.
- Pre-built images are available at `shivpatel/bitwarden_rs_dropbox_backup`.
- You only need to volume mount the `.sqlite3` file your bitwarden_rs container uses.
- Pick a secure `BACKUP_ENCRYPTION_KEY`. This is for added protection and will be needed when decrypting your backups.
- Follow the steps below to generate all values needed to grant upload access to your Dropbox account.
- To run backups on a different interval/time, modify the `Dockerfile` and build a custom image.
- This image will always run an extra backup on container start (regardless of cron interval) to ensure your setup is working.

### Generating DROPBOX_APP_KEY, DROPBOX_APP_SECRET and DROPBOX_REFRESH_TOKEN
1. Open the following URL in your Browser, and log in using your account: https://www.dropbox.com/developers/apps
2. Click on "Create App", then select "Choose an API: Scoped Access"
3. Choose the type of access you need: "App folder"
4. Enter the "App Name" that you prefer (e.g. MyVaultBackups); must be unique
5. Now, click on the "Create App" button.
6. Now the new configuration is opened, switch to tab "permissions" and check "files.metadata.read/write" and "files.content.read/write"
7. Now, click on the "Submit" button.
8. Once your app is created, you can find your "App key" (for DROPBOX_APP_KEY) and "App secret" (for DROPBOX_APP_SECRET) in the "Settings" tab.
9. Visit the following URL and replace {DROPBOX_APP_KEY} and {DROPBOX_APP_SECRET} in the input with the corresponding values : [CyberChef](https://gchq.github.io/CyberChef/#recipe=To_Base64('A-Za-z0-9%2B/%3D')&input=e0RST1BCT1hfQVBQX0tFWX06e0RST1BCT1hfU0VDUkVUfQ). Note the Output for use in the next steps.
10. Visit the following URL (replace {DROPBOX_APP_KEY} with your app key) and grant permissions: https://www.dropbox.com/oauth2/authorize?client_id={DROPBOX_APP_KEY}&token_access_type=offline&response_type=code. Note the access code for use in the next step
11. Visit https://apitester.com/shared/checks/c2a928a9c0c64c9faaf3251ab6a26bea.
12. In the "Post data" field, replace {ACCESS_CODE} with the access code generated previously
13. In the field next to "Authorization", replace {CYBERCHEF_OUTPUT} with the Output obtained from CyberChef previously.
14. Click Test.
15. Use the "refresh_token" value found in the "Reponse body" for DROPBOX_REFRESH_TOKEN

### Decrypting Backup
`openssl enc -d -aes256 -salt -pbkdf2 -in mybackup.tar.gz | tar xz -C my-folder`

### Restoring Backup to BitWarden_RS
Volume mount the decrypted `.sqlite3` file to your bitwarden_rs container. Done!

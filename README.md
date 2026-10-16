# SHEIN By JOY shipment tracker (GitHub Pages + Supabase)

Files:

- `index.html`: the whole app. It uses `@supabase/supabase-js` to sign in, then saves and fetches shipments, clients and settings.
- `supabase.sql`: creates the three tables and the security rules.

## 1. Create the tables

1. Open your project: https://supabase.com/dashboard/project/bozodsbzwokzwywvmxbz
2. SQL Editor, New query, paste the contents of `supabase.sql`, Run.

Tables created: `shipments`, `clients` (linked to a shipment, deleted with it) and `settings` (default threshold).

## 2. Create the login

The page is public on GitHub Pages, so the data is protected by a login plus row level security. Without signing in, the public key can read and write nothing.

1. Authentication, Users, Add user, Create new user. Enter an email and password and tick "Auto Confirm User".
2. Authentication, Sign In / Providers: turn off "Allow new users to sign up", so nobody else can register.

## 3. Paste the key

1. Project Settings, API Keys: copy the **anon** (or "publishable") key.
2. In `index.html`, replace `PASTE_YOUR_ANON_KEY_HERE` with it.

The project URL is already set to `https://bozodsbzwokzwywvmxbz.supabase.co`.
Never paste the `service_role` / secret key into this file. The anon key is meant to be public.

## 4. Publish on GitHub Pages

1. Create a repository and upload `index.html` (keep `supabase.sql` out of the repo if you prefer).
2. Settings, Pages, Deploy from a branch, `main` and `/ (root)`, Save.
3. Open the address GitHub shows, sign in with the user from step 2.

## Notes

- Money is stored as `numeric(12,2)`. Dates are stored with time zone.
- Shipment numbers (`Shipment #7`) are assigned by the app when a shipment is created.
- The page reloads from the database when you return to the tab, so changes made on a phone appear on the computer.

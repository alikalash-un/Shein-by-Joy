-- SHEIN By JOY shipment tracker: tables and security rules.
-- Run this once in Supabase: SQL Editor > New query > paste > Run.

create table if not exists public.shipments (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  seq         integer not null,
  status      text not null default 'open' check (status in ('open','closed','received','done')),
  opened_at   timestamptz not null default now(),
  closed_at   timestamptz,
  received_at timestamptz,
  done_at     timestamptz,
  threshold   numeric(12,2) not null default 1000 check (threshold > 0),
  purchase    numeric(12,2) check (purchase >= 0),
  customs     numeric(12,2) check (customs >= 0),
  sample      boolean not null default false,
  created_at  timestamptz not null default now()
);

create table if not exists public.clients (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  shipment_id uuid not null references public.shipments(id) on delete cascade,
  name        text not null,
  phone       text not null default '',
  amount      numeric(12,2) not null check (amount > 0),
  paid        boolean not null default false,
  created_at  timestamptz not null default now()
);

create index if not exists clients_shipment_idx on public.clients (shipment_id);
create index if not exists shipments_opened_idx on public.shipments (opened_at desc);

create table if not exists public.settings (
  user_id   uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  threshold numeric(12,2) not null default 1000 check (threshold > 0)
);

-- Row level security: only a signed-in user can touch their own rows.
-- Without a login, the public anon key can read and write nothing.
alter table public.shipments enable row level security;
alter table public.clients   enable row level security;
alter table public.settings  enable row level security;

drop policy if exists "own shipments" on public.shipments;
create policy "own shipments" on public.shipments
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

drop policy if exists "own clients" on public.clients;
create policy "own clients" on public.clients
  for all to authenticated
  using (user_id = auth.uid())
  with check (
    user_id = auth.uid()
    and exists (select 1 from public.shipments s where s.id = shipment_id and s.user_id = auth.uid())
  );

drop policy if exists "own settings" on public.settings;
create policy "own settings" on public.settings
  for all to authenticated
  using (user_id = auth.uid())
  with check (user_id = auth.uid());

revoke all on public.shipments, public.clients, public.settings from anon;

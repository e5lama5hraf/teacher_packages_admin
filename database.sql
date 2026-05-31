-- Supabase schema for EDUBE dashboard
-- افتح Supabase > SQL Editor وشغّل الكود ده مرة واحدة

create table if not exists public.app_state (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.app_state enable row level security;

-- يسمح للواجهة الأمامية بالقراءة والحفظ باستخدام anon key.
-- مناسب لو الموقع داخلي/خاص. لو الموقع عام، الأفضل تضيف Authentication وسياسات أدق.
drop policy if exists "Allow anon read app state" on public.app_state;
drop policy if exists "Allow anon upsert app state" on public.app_state;
drop policy if exists "Allow anon update app state" on public.app_state;
drop policy if exists "Allow anon delete app state" on public.app_state;

create policy "Allow anon read app state"
on public.app_state
for select
to anon
using (true);

create policy "Allow anon upsert app state"
on public.app_state
for insert
to anon
with check (true);

create policy "Allow anon update app state"
on public.app_state
for update
to anon
using (true)
with check (true);

insert into public.app_state (id, data)
values (
  'main',
  '{
    "teachers": [],
    "selectedStudio": "sadat",
    "timelineData": { "sadat": {}, "shebin": {} },
    "individualServices": []
  }'::jsonb
)
on conflict (id) do nothing;

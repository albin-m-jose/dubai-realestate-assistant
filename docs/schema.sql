create table messages (
  id bigint generated always as identity primary key,
  update_id bigint unique,
  channel text not null default 'telegram',
  chat_id bigint not null,
  direction text not null check (direction in ('in', 'out')),
  message_type text,
  text text,
  raw jsonb,
  created_at timestamptz not null default now()
);

create index on messages (chat_id, created_at);

alter table messages enable row level security;


create table customers (
  chat_id bigint primary key,
  hubspot_contact_id text,
  details jsonb not null default '{}',
  bot_status text not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table customers enable row level security;


#knowledge chunks
create extension if not exists vector;

create table public.knowledge_chunks (
    id uuid primary key default gen_random_uuid(),
    text text,
    metadata jsonb,
    embedding vector(1536) -- dimension matches the embedding model used
);
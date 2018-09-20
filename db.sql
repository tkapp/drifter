--- master

create table sequences(
  id integer primary key,
  description varchar(255) not null,
  value integer default 0
);

create table custom_fields(
  item_id integer,
  custom_field_id integer,
  name varchar(255) not null,
  data_type integer not null,
  primary key(item_id, custom_field_id),
  foreign key(item_id) references items(item_id) on delete cascade
);

create table custom_field_options(
  item_id integer,
  custom_field_id integer,
  option_id integer,
  value integer not null,
  order integer not null,
  primary key(item_id, custom_field_id, option_id),
  foreign key(item_id, custom_field_id) references custom_fields(item_id, custom_field_id) on delete cascade
);

--- resource

create table items(
  item_id integer,
  subject varchar(255) not null,
  text text,
  html text,
  parent_item_id integer not null,
  private boolean not null,
  visible boolean default false not null,
  auther integer not null,
  created_on datetime default CURRENT_TIMESTAMP not null,
  updated_on datetime default CURRENT_TIMESTAMP not null,
  primary key(item_id),
  foreign key(parent_item_id) references items(item_id) on delete cascade,
  foreign key auther references users(user_id) on update set null,
  index(parent_item_id),
);

insert into items values(0, 'system values', null, null, 0, false, true, 0, now(), now());
insert into items values(1, 'アイテム一覧', null, null, 1, false, true, 0,now(), now());

create table custom_values(
  item_id integer,
  custom_field_id integer,
  value varchar(255),
  primary key(item_id, custom_field_id),
  foreign key(item_id, custom_field_id) references custom_fields(item_id, custom_field_id) on delete cascade,
);

create table comments(
  comment_id integer,
  item_id integer,
  comment text not null,
  auther integer,
  created_on datetime default CURRENT_TIMESTAMP not null,
  updated_on datetime default CURRENT_TIMESTAMP not null,
  primary key(comment_id),
  foreign key(item_id) references items(item_id) on delete cascade,
  foreign key auther references users(user_id) on update set null,
  index(item_id)
);

create table item_histories(
  item_id integer,
  seq integer,
  text text,
  diff text,
  auther integer,
  created_on datetime default CURRENT_TIMESTAMP not null,
  primary key(item_id, seq),
  foreign key item_id references items(item_id) on delete cascade,
  foreign key auther references users(user_id) on update set null,
);

--- account
create table users(
  user_id integer,
  email_address varchar(255) not null unique,
  name varchar(255) not null,
  password varchar(40) not null,
  enable boolean default true not null,
  created_on datetime default CURRENT_TIMESTAMP,
  primary key(user_id)
);

insert into users values(0, 'admin@', 'admin', set_password('admin'), true, now());

create table groups(
  group_id integer,
  group_name varchar(255) not null,
  description text,
  primary key(group_id)
);

create table members(
  group_id integer,
  user_id integer,
  primary key(group_id, user_id),
  foreign key(group_id) references groups(group_id) on delete cascade,
  foreign key(user_id) references users(user_id) on delete cascade
);

-- custom search

--

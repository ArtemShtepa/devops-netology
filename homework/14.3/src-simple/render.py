#!/usr/bin/env python
from jinja2 import Environment, FileSystemLoader

env = Environment(
  loader = FileSystemLoader('templates')
)
template = env.get_template('nginx.vhosts.jinja')

domains = [{'domain':'netology.ru', 'ip':'10.10.10.10'}]
for item in domains:
  config = template.render(
    domain = item['domain'], ip=item['ip']
  )

with open('nginx.conf', 'w') as f:
  f.write(config)

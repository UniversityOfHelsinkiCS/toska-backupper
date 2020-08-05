# TOSKA BACKUPPER

`curl -F file=@<filename> http://localhost:3000/long/path/to/file?token=<token>`

# How to access the files?

Windows https://helpdesk.it.helsinki.fi/ohjeet/tietokone-ja-tulostaminen/ryhmatallennustilan-yhdistaminen-kotikoneelle

Mac https://helpdesk.it.helsinki.fi/ohjeet/tallentaminen-ja-jakaminen/henkilokohtainen-tallennustila/koti-ja-ryhmatallennustilaan

Ubuntu/Cubbli https://helpdesk.it.helsinki.fi/ohjeet/kirjautuminen-ja-yhteydet/ryhmatallennustilan-p-asema-yhdistaminen-cubbli-koneelle

# How to use backer

Add the following to docker-compose file

```
backer:
  image: toska/backer:latest
  container_name: backer
  networks:
    - database # if needed
  restart: unless-stopped
  environment:
    - TOKEN_SECRET=very_big_sicrit # token for backupper
    - BACKUPPER_URL=jotainroskaa # url for backupper
    - CRON_SCHEDULE=* * * * * # add cron schedule (script defaults to 1am everyday)
    - SERVICE_NAME=lol # service name
    - DB_URL=possu_url # database url
```

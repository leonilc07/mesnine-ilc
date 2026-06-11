# Mesnine ILC — Informacijski sistem za vodenje evidence mesnin

Spletna aplikacija za vodenje evidence porabe suhomesnatih izdelkov v podjetju Mesnine ILC, razvita v Oracle APEX 24.2.

## Opis

Aplikacija podpira celoten delovni tok od prevzema prašičev do prodaje končnih izdelkov. Vključuje sledljivost po živalih in serijah, upravljanje zalog v realnem času, evidentiranje dobav, izstavljanje računov in finančni pregled.

## Tehnologije

- **Oracle Database XE 21c** — relacijska baza podatkov (Docker, Oracle Linux 8)
- **Oracle APEX 24.2** — razvojno okolje za spletno aplikacijo
- **Oracle ORDS 23.3** — spletni strežnik (systemd servis)
- **Ubuntu 22.04 LTS** — operacijski sistem strežnika (Contabo VPS)
- **Cloudflare Tunnel** — javni dostop prek domene mesnine-ilc.com

## Struktura repozitorija

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


## Namestitev

### 1. Baza podatkov

Zaženi SQL skripte v naslednjem vrstnem redu v Oracle SQL Workshop ali SQL*Plus:

```sql
00_osnove_tabele.sql
01_tabele.sql
02_sekvence.sql
03_triggerji.sql
04_pogledi.sql
05_check_constrainti.sql
07_podatki.sql
```


## Uporabniške vloge

| Vloga | Opis |
|-------|------|
| ADMIN | Neomejen dostop, upravljanje šifrantov |
| DELAVEC | Vnos živali, serij, hrenovk, dobav, računov |
| RACUNOVODJA | Finančni pregled, cene, stranke, dobavitelji |

## Avtor

Leon Ilc — Zaključna naloga, Šolski center Nova Gorica, 2025/2026

Mentor: dr. Boštjan Vouk

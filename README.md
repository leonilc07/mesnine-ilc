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

/
├── sql/
│   ├── 00_osnove_tabele.sql       # Osnovne tabele
│   ├── 01_tabele.sql              # Vse tabele
│   ├── 02_sekvence.sql            # Zaporedja za ID-je
│   ├── 03_triggerji.sql           # Sprožilci
│   ├── 04_pogledi.sql             # Pogledi (views)
│   ├── 05_check_constrainti.sql   # Omejitve
│   ├── 06_drop_constrainti.sql    # Brisanje omejitev
│   └── 07_podatki.sql             # Začetni podatki
├── apex/
│   └── aplikacija.sql             # APEX export aplikacije
└── README.md

## Namestitev

### 1. Baza podatkov

Zaženi SQL skripte v naslednjem vrstnem redu v Oracle SQL Workshop ali SQL*Plus:

```sql
@00_osnove_tabele.sql
@01_tabele.sql
@02_sekvence.sql
@03_triggerji.sql
@04_pogledi.sql
@05_check_constrainti.sql
@07_podatki.sql
```

### 2. APEX aplikacija

1. Odpri Oracle APEX App Builder
2. Klikni **Import**
3. Izberi datoteko `apex/aplikacija.sql`
4. Sledi čarovniku za uvoz

## Uporabniške vloge

| Vloga | Opis |
|-------|------|
| ADMIN | Neomejen dostop, upravljanje šifrantov |
| DELAVEC | Vnos živali, serij, hrenovk, dobav, računov |
| RACUNOVODJA | Finančni pregled, cene, stranke, dobavitelji |

## Avtor

Leon Ilc — Zaključna naloga, Šolski center Nova Gorica, 2025/2026

Mentor: dr. Boštjan Vouk

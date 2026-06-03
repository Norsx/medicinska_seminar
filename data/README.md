# data/

## `data/raw/`
Izvorni, netaknuti podaci. Ovo mogu biti izvješća, slike s kamera, preuzete tablice ili neobrađeni datasetovi.
Sadržaj ovog direktorija se ne smije mijenjati putem koda - služi samo za čitanje.

## `data/processed/`
Obrađeni podaci, grafovi, i modeli.
**PRAVILO:** Svi obrađeni podaci moraju ići u podfoldere s nazivom oblika `odkuddolazepodaci_ddmmyyyy_hhmmss`.

## `data/sources/`
PDF izvori za RAG pretragu — knjige, skripte, članci. Stavi ovdje i pokreni `python ~/.agentbrain/scripts/rag/ingest.py`.

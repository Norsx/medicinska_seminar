# Zaključci iz izvora: Upravljački pristupi za autonomno robotsko ultrazvučno snimanje

Ovaj dokument sadrži detaljne analize, sažetke, kliničke podatke i tablice konkretnih robotskih sustava izvučene iz istraživačkih izvora za seminarski rad iz kolegija Medicinska robotika.

---

## 1. Struktura zadatka i što istraživati

Zadatak je **teorijski seminar** koji traži:
1. Pregled osnova UZ snimanja i robotski potpomognutih sustava.
2. Usporedbu upravljačkih pristupa (force control, impedance, admittance, hybrid).
3. Analizu ≥ 3 konkretna robotska sustava iz literature.
4. Za naprednu varijantu: napredne pristupe (RL, image-guided control, adaptive force) + vlastiti prijedlog arhitekture.

**Ključna nit:** Kako i zašto je regulacija kontaktne sile presudna za kvalitetu UZ slike i sigurnost pacijenta.

---

## 2. Detaljne analize primarnih survey radova

### S1. Jiang et al. (2023)
* **Ključni zaključci:** Najpotpuniji pregled područja do danas. Sadrži taksonomiju upravljačkih pristupa (hybrid force/position, admittance/impedance, pasivni mehanizmi).
* **Tehnički parametri:** Kontaktna sila treba biti u rasponu **1.2–20 N** za optimalnu kvalitetu slike i izbjegavanje deformacija/ozljeda tkiva.
* Pokriva teleoperirane, poluautonomne i autonomne sustave.

### S2. Qin et al. (2026)
* **Ključni zaključci:** Najnoviji pregled (2026.) koji analizira autonomne RUS akvizicije. Mapira razlike između razina autonomije (RC-RUS, SA-RUS, AU-RUS).
* **Tehnički parametri:** Ističe da admittance control dominira u praktičnim primjenama cobota jer omogućuje jednostavno mapiranje sile na brzine/pozicije robota bez potrebe za modeliranjem dinamike robota.

### S3. von Haxthausen et al. (2021)
* **Ključni zaključci:** Klasificira sustave prema LORA (Level of Robot Autonomy). Donosi detaljne rasprave o sigurnosnim aspektima i nedostatku opsežnih kliničkih ispitivanja na ljudima za autonomne robote.

### S4. IEEE Access Survey (2025)
* **Ključni zaključci:** Analizira 60+ radova iz razdoblja 2022.–2025. Ističe rast cobot rješenja (npr. Franka Panda, UR serija) i primjenu F/T senzora na vrhu robota.
* **Problem:** Mnogi sustavi ignoriraju komponente sile paralelne s površinom (surface-parallel forces).

### S5. MDPI Sensors Review (2026)
* **Ključni zaključci:** Analizira RUS iz perspektive "decision-oriented autonomy". Mapira metode na tri ključna stupa: percepciju, donošenje odluka i izvršavanje.

---

## 3. Analiza specifičnih upravljačkih pristupa

### 3.1 Admittance Control (Upravljanje admitancijom)
* **Jednadžba:** 
  $$M_d \ddot{x} + B_d \dot{x} + K_d x = F_{ext}$$
  gdje su $M_d, B_d, K_d$ željene virtualna masa, prigušenje i krutost, a $F_{ext}$ vanjska kontaktna sila.
* **A1 (Jiang 2024):** Predlaže *integral adaptive admittance control* za stabilno praćenje sile na nesigurnim mekim tkivima, čime se eliminira statička greška.
* **A2 (IEEE TII 2024):** Rješava problem respiratornog gibanja kombiniranjem admittance kontrole s prediktivnim algoritmom za disanje.
* **Prednosti:** Stabilnost na tvrdim površinama, jednostavna integracija na industrijske robote koji imaju samo pozicijsko sučelje.

### 3.2 Hybrid Force/Position Control (Hibridno upravljanje silom/pozicijom)
* **Koncept:** Dekopling zadataka na podprostore sile (ortogonalno na površinu kože) i pozicije/brzine (tangencijalno duž površine kože).
* **H1 (ICRA 2022):** Koristi Bayesovsku optimizaciju za pronalazak površine i 6-osni hibridni kontroler za održavanje kontakta.
* **H2 (TRO 2023):** Primjenjuje hibridno force-velocity upravljanje bazirano na admitanciji za skeniranje dojki, osiguravajući normalnu orijentaciju sonde.
* **H4 (Wuhan 2026):** Primjena na xArm6 robotu za thyroid scanning. Ostvarena točnost sile s RMSE < 0.25 N i vrijeme smirivanja od ~0.73 sekunde na ljudskom volonteru.

### 3.3 Impedance Control (Upravljanje impedancijom)
* **Koncept:** Kontrolira dinamički odnos između pozicije i sile (robot se ponaša kao virtualna opruga i prigušivač).
* **I1 (IEEE 2023):** Koristi 3D modeliranje/point cloud za kompenzaciju normale skeniranja.
* **I2 (SAE 2026):** *Adaptive speed-regulated impedance control* smanjuje grešku praćenja sile pri većim brzinama skeniranja za 31% do 37%.

### 3.4 Pasivno/Hardversko upravljanje silom
* **P1 (CBS 2025):** Razvija poseban end-effektor s pasivnim konstantnim mehanizmom sile (opruge/zračni cilindri) koji mehanički prigušuje nagle pokrete i održava silu, što je sigurnije od isključivo softverske regulacije.

---

## 4. Pregled konkretnih robotskih sustava iz literature

| Sustav | Robot | Senzor | Tip kontrole | Primjena | Razine/Parametri |
|--------|-------|--------|--------------|----------|------------------|
| **HaptiScan** | UR5 | 6-axis F/T + Phantom Omni | Admittance + haptic feedback | Generalno, teleop | Daljinsko upravljanje s povratnom silom |
| **Breast scanning (Jiang 2023)** | KUKA LBR Med7 | Ugrađeni senzori momenta | Hybrid force-velocity (admittance) | Dojka | Integrirani model deformacije tkiva |
| **Thyroid scanning (Wuhan 2026)** | xArm6 | 6D F/T | Admittance (2. red MSD) | Štitnjača | Target sila 5.0 N, settling time ~0.73s |
| **Abdominal scanning (CMU 2022)** | Cobot | 6-axis F/T | Hybrid force-position + Bayesian Opt. | Abdomen | Bayesovska optimizacija za orijentaciju |
| **Auto-RUSS (Frontiers 2025)** | 7-DOF ruka | F/T senzor | PD force control (Z-os) | Generalno | Jednostavna autonomna petlja |

---

## 5. Napredni upravljački pristupi

### 5.1 Image-Guided Force Control (Vizualno vođeno upravljanje silom)
* **IG1 (Akbari 2021):** Integrira SVM klasifikator koji analizira UZ sliku u realnom vremenu (šum, kompresija, korelacija) i dinamički povećava silu ako se kvaliteta slike pogorša zbog lošeg akustičkog kontakta.
* **IG2 (Twente 2024):** Uspoređuje force-based i image-based kontrolere te zaključuje da hibridni pristup (sila + vizualne mape pouzdanosti slike) daje najbolje rezultate.

### 5.2 Learning-Based Control (Upravljanje temeljeno na učenju)
* **L1 (TRO 2024):** Koristi učenje iz demonstracija (Inverse Reinforcement Learning - IRL) kako bi robot naučio prilagođavati krutost sonde u nepoznatim i promjenjivim okolinama na temelju ljudskog kretanja.
* **L2 (IEEE 2025):** Primjenjuje *Offline Reinforcement Learning* za adaptivnu impedanciju kako bi se izbjeglo rizično online istraživanje algoritma na živim pacijentima.

### 5.3 Kompenzacija respiratornog gibanja
* **M2 (IEEE 2025):** Vision-haptic fuzija za praćenje i kompenzaciju disanja u realnom vremenu s točnošću praćenja sile od 0.295 N i prostornim odstupanjem od samo 0.48 mm.

---

## 6. Klinički referentni podaci o kontaktnoj sili

* **Izvor K1 (AAU 2021):** Mjerenja sila na 40 trudnica tijekom ginekoloških pregleda pokazala su:
  * **Srednja aksijalna sila:** **9.05 N**
  * **Maksimalna zabilježena sila:** **37.63 N**
  * Klinički zaključak: BMI pacijentice i iskustvo liječnika izravno koreliraju s količinom sile potrebnim za dobivanje jasne slike. Ovi podaci služe kao osnova za postavljanje sigurnosnih granica ($F_{max} < 20 N$) u robotskim sustavima.

---

## 7. Preporučena raspodjela izvora po sekcijama seminara

| Sekcija rada | Izvori | Uloga u tekstu |
|---|---|---|
| **Uvod i Motivacija** | S1, S2, S3 | Opći pregled, stope rasta, definicija RUS |
| **Osnove UZ + robotski sustavi** | S3, S4, K1 | Razine autonomije, kliničke potrebe za silom |
| **Upravljačke strategije** | A1, U1, U2, U3 | Teorijska i matematička usporedba |
| **Pregled konkretnih sustava** | Tablica iz Sekcije 4, H2, H4 | Analiza 3+ sustava (zahtjev Varijante B) |
| **Napredna poglavlja (Var. C)** | IG1-IG4, L1-L3, M1-M3 | Image-guided, RL, kompenzacija respiratornog gibanja |
| **Sigurnost i Rasprava** | M3, S3, U4, K1 | Sigurnosne granice sile, klinički izazovi |

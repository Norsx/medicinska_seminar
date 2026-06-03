# Istraživački pregled izvora: Upravljački pristupi za autonomno robotsko ultrazvučno snimanje

> **Seminarski rad – Medicinska robotika, FSBU 2025./2026.**  
> Fokus: Upravljanje kontaktnom silom između ultrazvučne sonde i tijela pacijenta  
> Razina: Varijanta B (ocjena 4) — detaljno preporučena  
> Kontakt: Tara Knežević

***

## 1. Struktura zadatka i što istraživati

Zadatak je **teorijski seminar** koji traži:
1. Pregled osnova UZ snimanja i robotski potpomognutih sustava
2. Usporedbu upravljačkih pristupa (force control, impedance, admittance, hybrid)
3. Analizu ≥ 3 konkretna robotska sustava iz literature
4. Za Varijantu C: napredne pristupe (RL, image-guided control, adaptive force) + vlastiti prijedlog arhitekture

Ključna nit koja prolazi cijelim radom: **kako i zašto je regulacija kontaktne sile presudna za kvalitetu UZ slike i sigurnost pacijenta.**

***

## 2. Primarni survey radovi (obvezno koristiti)

Ovi radovi su **pregledi područja** — idealni za uvod, Related Work sekciju i usporedbu pristupa. Svaki pokriva desetke originalnih radova.

### S1. Jiang et al. (2023) — Elsevier Medical Image Analysis ⭐⭐⭐⭐⭐
**Robotic Ultrasound Imaging: State-of-the-Art and Future Perspectives**  
Zhongliang Jiang, Septimiu E. Salcudean, Nassir Navab — TU München  
Dostupno: [arxiv.org/pdf/2307.05545.pdf](https://arxiv.org/pdf/2307.05545.pdf)

**Zašto je ključan:** Najpotpuniji pregled do danas. Sadrži detaljnu taksonomiju upravljačkih pristupa sile (hybrid force/position, compliant/admittance/impedance, spring-based mehanizmi), tablice konkretnih sustava, robote, senzore, aplikacije i podatke. Poglavlje 4.1 "Force Control Approaches" direktno pokriva srž teme.[^1]

- Tablica 2 daje pregled svih metoda upravljanja silom s robotima, senzorima i primjenama
- Pokriva teleoperirane, semi-autonomne i autonomne sustave
- Ukazuje da kontaktna sila treba biti u rasponu **1.2–20 N** za kvalitetne UZ slike

***

### S2. Qin et al. (2026) — MDPI Sensors ⭐⭐⭐⭐⭐
**A Review and Perspective of Techniques for Autonomous Robotic Ultrasound Acquisitions**  
Yanding Qin, Nankai University  
Dostupno: [pmc.ncbi.nlm.nih.gov/articles/PMC13074658/](https://pmc.ncbi.nlm.nih.gov/articles/PMC13074658/)

**Zašto je ključan:** Najsvježiji sveobuhvatni pregled (2026.). Sadrži tablice sustava (≥ 12 sustava s robotima, senzorima, aplikacijama), detaljnu sekciju o force sensitivity and control, razliku između RC-RUS / SA-RUS / AU-RUS autonomije, te raspravu o deployment bottlenecks.[^2]

- Poglavlje 3.1 "Force Sensitivity and Control" — izravno primjenjivo
- Navodi da admittance control dominira u praksi
- Tabele sustava: Franka Panda, KUKA iiwa, UR5, xArm6 — s navedenim tipovima senzora i kontrole

***

### S3. von Haxthausen et al. (2021) — Current Robot Reports ⭐⭐⭐⭐
**Medical Robotics for Ultrasound Imaging: Current Systems and Future Trends**  
University of Lübeck  
Dostupno: [pmc.ncbi.nlm.nih.gov/articles/PMC7898497/](https://pmc.ncbi.nlm.nih.gov/articles/PMC7898497/)

**Zašto je ključan:** Organizira sustave prema LORA (Level of Robot Autonomy) — odlična polazna točka za sekciju u seminar. Tablice teleoperated i autonomous sustava (Tablica 1 i 2) s potpunim tehničkim specifikacijama.[^3]

- Razmatra sigurnosne aspekte upravljanja silom u medicinskoj robotici
- Opisuje impedance/admittance control u kontekstu lightweight robota (KUKA iiwa)
- Ističe nedostatak kliničkih validacija za autonomne sustave

***

### S4. IEEE Access Survey (2025) ⭐⭐⭐⭐
**A Survey of Autonomous Robotic Ultrasound Scanning Systems**  
Dostupno: [ieeexplore.ieee.org/document/11016698/](https://ieeexplore.ieee.org/document/11016698/)

**Zašto je ključan:** Noviji survey koji analizira **60+ publikacija** (2022.–2025.), ističe rastuću primjenu cobot rješenja s 6-DOF F/T senzorima, reinforcement learning i image-guided visual servoing.[^4][^5]

- Identificira ključne nedostatke: surface-parallel force komponente se često ignoriraju
- Naglašava integraciju real-time UZ image feedbacka u petlju upravljanja

***

### S5. MDPI Sensors Review (2026) ⭐⭐⭐⭐
**A Review and Perspective of Techniques for Autonomous Robotic Ultrasound Acquisitions**  
Dostupno: [mdpi.com/1424-8220/26/7/2081](https://www.mdpi.com/1424-8220/26/7/2081)

**Zašto je ključan:** Decision-oriented autonomy perspektiva — mapira metode na workflow komponente (perception, decision-making, execution). Sekcija o force sensitivity and control pokriva sve relevantne pristupe.[^6]

***

## 3. Radovi o specifičnim upravljačkim pristupima (za sekciju Metodologija)

### 3.1 Admittance Control

#### A1. Jiang et al. (2024) — MDPI Actuators ⭐⭐⭐⭐⭐
**Force Tracking Control Method for Robotic Ultrasound Scanning System under Soft Uncertain Environment**  
Dostupno: [mdpi.com/2076-0825/13/2/62](https://www.mdpi.com/2076-0825/13/2/62)

**Direktno primjenjivo:** Predlaže **integral adaptive admittance control** koji nadmašuje klasični admittance control u preciznosti. Detaljan matematički model, simulacija + eksperiment na stvarnom sustavu.[^7]

- Ključna jednadžba admittance kontrolera: \( M_d \ddot{x} + B_d \dot{x} + K_d x = F_{ext} \)
- Online estimacija parametara okoline za korekciju referentne trajektorije
- Rezultati: uspješno održavanje konstantne sile u nesigurnom mekanom okolišu

***

#### A2. IEEE TII (2024) — Robot-Assisted Probe Force Control Under Respiration-Induced Motion ⭐⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/10637095/](https://ieeexplore.ieee.org/document/10637095/)

**Zašto je važan:** Rješava problem **respiratornog gibanja pacijenta** — jedan od ključnih izazova iz Varijante C. Kombinira admittance control s adaptive kontrolerom koji predviđa disturbance disanja.[^8]

- Dva načina rada: admittance (pozicioniranje) + adaptive (stabilno snimanje)
- Eksperiment na abdomen fantomu sa spužvom koja simulira dah

***

#### A3. Conti et al. (2010/2011) — Stanford Robotics ⭐⭐⭐
**Interface Design and Control Strategies for a Robot Assisted Ultrasound Examination System**  
Dostupno: [khatib.stanford.edu/publications/pdfs/Conti_2010_ISER.pdf](https://khatib.stanford.edu/publications/pdfs/Conti_2010_ISER.pdf)

**Klasičan rad:** Force controller koji održava konstantnu silu između sonde i kože pacijenta dok robot prati zadanu putanju. Stanford Robotics Lab.[^9]

***

#### A4. Admittance control for robotic-assisted tele-echography (2013) — IEEE ⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/6766502/](http://ieeexplore.ieee.org/document/6766502/)

**Seminalni rad** o admittance control u kontekstu teleoperirane ehografije.[^10]

***

### 3.2 Hybrid Force/Position Control

#### H1. IEEE ICRA (2022) — Autonomous Ultrasound Scanning using Bayesian Optimization and Hybrid Force Control ⭐⭐⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/9812410/](https://ieeexplore.ieee.org/document/9812410/)  
PDF: [biorobotics.ri.cmu.edu/.../AutonomousUltrasoundScanning...pdf](http://biorobotics.ri.cmu.edu/papers/paperUploads/AutonomousUltrasoundScanning_Raghavv_Abhi.pdf)

**Direktno primjenjivo:** Kombinira Bayesian Optimization za pronalazak optimalnog područja skeniranja i **6-axis hybrid force-position controller** za stabilni kontakt. Eksperimenti na dva fantoma.[^11][^12]

***

#### H2. IEEE TRO (2023) — Full-Coverage Path Planning and Stable Interaction Control for Automated Robotic Breast Ultrasound Scanning ⭐⭐⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/9889084/](https://ieeexplore.ieee.org/document/9889084/)

**Ključan rad za Varijantu B:** Hybrid force-velocity control framework baziran na admittance kontrolu. Uspoređuje normalan smjer (force control) i tangencijalni smjer (position/velocity control). Eksperimenti na phantomu + in vivo.[^13]

- Uključuje contact force-strain regression model za deformaciju tkiva
- Demonstrira održavanje konstantne sile i normalne orijentacije sonde

***

#### H3. IEEE (2025) — Cascaded Force/Position Hybrid Control ⭐⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/11277546/](https://ieeexplore.ieee.org/document/11277546/)

**Noviji rad:** Dekompozicija prostora zadataka u normalni smjer (force control) i tangencijalni smjer (impedance control). Rješava problem iznenadnog gubitka kontakta.[^14]

- Cartesian impedance u tangencijalnom smjeru + kaskadni force control (impedance feedforward + PID feedback) u normalnom
- Abdominal phantom eksperiment

***

#### H4. Thyroid Scanning — Adaptive Force/Position Hybrid Control (2026) ⭐⭐⭐⭐
Dostupno: [iopscience.iop.org/article/10.1088/1742-6596/3240/1/012037](https://iopscience.iop.org/article/10.1088/1742-6596/3240/1/012037)

**Najsvježiji primjer specifične primjene:** xArm6 robot + 6D F/T senzor, admittance control, target sila 5.0 N, RMSE < 0.25 N, settling time ≈ 0.73 s na volonteru.[^15]

***

### 3.3 Impedance Control

#### I1. IEEE (2022/2023) — Hybrid Force/Impedance Control for Ultrasound Robot based on 3D Modeling ⭐⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/10136959/](https://ieeexplore.ieee.org/document/10136959/)

**Direktno primjenjivo:** Jasna usporedba impedance (tangencijalni smjer) i direct force control (normalni smjer). Koristi point cloud za scan normal kompenzaciju.[^16]

***

#### I2. SAE (2026) — Adaptive Speed-Regulated Impedance Control ⭐⭐⭐⭐
Dostupno: [saemobilus.sae.org/papers/adaptive-speed-regulated-impedance-control-robotic-ultrasound-scanning...](https://saemobilus.sae.org/papers/adaptive-speed-regulated-impedance-control-robotic-ultrasound-scanning-reducing-constant-force)

**Najsvježiji rad:** Kombinira spline interpolation s impedance control za smanjenje greške praćenja sile pri visokim brzinama. Pokazuje redukciju pogreške od **31.1%/37.4%** u usporedbi s klasičnim impedance control.[^17]

***

#### I3. arXiv (2025) — Interactive Force-Impedance Control ⭐⭐⭐
Dostupno: [arxiv.org/html/2510.17341v1](https://arxiv.org/html/2510.17341v1)

**Napredniji pristup:** Unified Interactive Force-Impedance Control (IFIC) framework baziran na port-Hamiltonian formulaciji, garantira pasivnost sustava.[^18]

***

### 3.4 Passive / Hardware Force Control (alternativni pristup)

#### P1. Robotic Ultrasound Scanning End-Effector with Adjustable Constant Contact Force (2025) ⭐⭐⭐⭐
Dostupno: [spj.science.org/doi/10.34133/cbsystems.0251](https://spj.science.org/doi/10.34133/cbsystems.0251)

**Zanimljiv alternativni pristup:** Hibridni aktivno-pasivni pristup — passivni constant-force mehanizam za bufferiranje + aktivni sustav za dugotrajno pozicioniranje. Eksperimenti na silikonskim modelima i ljudskim volonterima.[^19]

***

## 4. Konkretni robotski sustavi za pregled (Varijanta B zahtijeva ≥ 3)

Preporučeni skup od 4–5 sustava:

| Sustav | Robot | Senzor | Tip kontrole | Primjena | Izvor |
|--------|-------|--------|--------------|----------|-------|
| **HaptiScan** | UR5 | 6-axis F/T + Phantom Omni | Admittance + haptic feedback | Generalno, teleop | [^20] |
| **Breast scanning (Jiang et al. 2023)** | KUKA LBR Med7 | Built-in torque sensors | Hybrid force-velocity (admittance) | Dojka | [^13] |
| **Thyroid scanning (Wuhan 2026)** | xArm6 | 6D F/T | Admittance (2nd order MSD) | Štitnjača | [^15] |
| **Abdominal scanning (CMU 2022)** | Nije specificiran | 6-axis F/T | Hybrid force-position + Bayesian Opt. | Abdomen | [^11] |
| **Auto-RUSS (Frontiers 2025)** | 7-DOF | F/T senzor | PD force control (Z-os) | Generalno | [^21][^22] |
| **COVID-19 remote system (Akbari)** | Dexterous robot arm | Admittance built-in | Admittance + image quality feedback | Generalno | [^23] |

Za **svaki sustav** seminar treba navesti: robot, senzor, tip upravljanja, cilj snimanja, razinu autonomije, ograničenja — upravo kako traži zadatak (Varijanta B).

***

## 5. Radovi o image-guided force control (za Varijantu C)

### IG1. Akbari et al. (2021) — Robotic Ultrasound Scanning with Real-Time Image-based Force Adjustment ⭐⭐⭐⭐⭐
PDF: [ece.ualberta.ca/.../Frontiers-DDD-Akbari-2021.pdf](http://www.ece.ualberta.ca/~tbs/pmwiki/pdf/Frontiers-DDD-Akbari-2021.pdf)

**Direktno primjenjivo za Varijantu C:** Sustav koristi SVM classifier na UZ image featurama (correlation, compression, noise) za automatsko prilagođavanje kontaktne sile. Ako image quality pada → sila se povećava. Kombinira admittance control s image quality feedbackom.[^23]

***

### IG2. Comparison Between Force and Ultrasound Image-Based Controllers (2024) — Univ. Twente ⭐⭐⭐⭐
Dostupno: [research.utwente.nl/...](https://research.utwente.nl/en/publications/comparison-between-force-andultrasound-image-based-controllers-fo/)  
PDF: [research.utwente.nl/files/501424076/978-3-031-76428-8_73.pdf](https://research.utwente.nl/files/501424076/978-3-031-76428-8_73.pdf)

**Odlično za usporedbu:** Direktno uspoređuje force-based controller i image-based controller (confidence maps). Hybrid controller kombinira oba pristupa.[^24][^25]

***

### IG3. Smooth Path Planning and Dynamic Contact Force Regulation (2025) — IEEE RA-L ⭐⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/11146611/](https://ieeexplore.ieee.org/document/11146611/)

**Za Varijantu C:** Dinamička regulacija sile bazirana na UZ image confidence — sila se prilagođava ovisno o lokalnoj kvaliteti slike, ne samo o fiksnoj referenci.[^26]

***

### IG4. Explicit force-based control strategies (2026) — SAGE ⭐⭐⭐⭐
Dostupno: [journals.sagepub.com/doi/abs/10.1177/02783649261441635](https://journals.sagepub.com/doi/abs/10.1177/02783649261441635)

**Direktna usporedba:** Eksperimentalni rezultati pokazuju da explicit force-based control poboljšava UZ image quality mjerenu confidence maps u usporedbi s alternativnim metodama.[^27]

***

## 6. Radovi o learning-based control (Varijanta C)

### L1. IEEE TRO (2024) — Inverse-Reinforcement-Learning-Based Robotic Ultrasound Active Compliance Control ⭐⭐⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/10061438/](https://ieeexplore.ieee.org/document/10061438/)

**Ključan za Varijantu C:** IRL-based active compliance control — robot uči iz ekspertskih demonstracija kako varijabilno upravljati silom u nesigurnim okolinama. Treniran na jednostavnim fantomima, evaluiran na složenim.[^28]

***

### L2. IEEE (2025) — Offline Reinforcement Learning-Based Adaptive Impedance Control ⭐⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/11377341/](https://ieeexplore.ieee.org/document/11377341/)

**Direktno primjenjivo:** Offline RL-based adaptive impedance control za varijabilno praćenje sile — ne zahtijeva online eksperimentiranje na pacijentima (sigurnosno relevantno). Phantom + in vivo eksperimenti.[^29]

***

### L3. IEEE (2021) — Autonomic Robotic Ultrasound Imaging System Based on Reinforcement Learning ⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/9336261/](https://ieeexplore.ieee.org/document/9336261/)  
PubMed: [pubmed.ncbi.nlm.nih.gov/33497322/](https://pubmed.ncbi.nlm.nih.gov/33497322/)

**Kombinira RL s admittance control** za force-to-displacement konverziju i kontrolu sonde.[^30][^31]

***

## 7. Radovi o sigurnosti i kompenzaciji gibanja (za raspravu i Varijantu C)

### M1. IEEE (2025) — Robotic Respiratory Liver Motion Compensation for Stable Ultrasound ⭐⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/11131517/](https://ieeexplore.ieee.org/document/11131517/)

**Za sekciju robustnosti:** Adaptive variable admittance controller za kompenzaciju respiratornog gibanja jetre.[^32]

***

### M2. IEEE (2025) — Respiratory Motion-Robust Robotic Ultrasound via Vision-Haptic Fusion Control ⭐⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/11184711/](https://ieeexplore.ieee.org/document/11184711/)

**Za Varijantu C — robustnost:** Vision-haptic fusion motion control framework. Admittance controller s model predictive capabilities. Točnost praćenja sile: 0.295 N, prostorna distorzija: 0.48 mm.[^33]

***

### M3. Haptic Feedback — IEEE (2025) — Haptic Feedback for Telerobotic Ultrasound Procedures ⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/11262065/](https://ieeexplore.ieee.org/document/11262065/)

**Za sekciju sigurnosti + shared autonomy:** UR5 + F/T senzor + haptic interface. Real-time force-limiting algorithm smanjuje prekomjernu silu u teleoperiranom sustavu.[^34]

***

### M4. Path Generation and Stable Interaction Control for Breast Ultrasound (2025) — IEEE ⭐⭐⭐⭐
Dostupno: [ieeexplore.ieee.org/document/11482176/](https://ieeexplore.ieee.org/document/11482176/)

**Konkretni rezultati:** Hybrid admittance control za breast scanning. Maksimalna greška praćenja sile: 0.1265–0.1810 N. Uključuje force-deformation karakteristike dojke.[^35]

***

## 8. Klinički podaci o kontaktnoj sili

### K1. Probe Contact Forces during Obstetric Ultrasound Scans (2021) — AAU ⭐⭐⭐⭐
Dostupno: [vbn.aau.dk/en/publications/probe-contact-forces-during-obstetric-ultrasound-scans...](https://vbn.aau.dk/en/publications/probe-contact-forces-during-obstetric-ultrasound-scans-a-design-p/)

**Klinički referentni podaci:** Mjerenja sila na 40 trudnica. Srednja aksijalna kontaktna sila: **9.05 N**, maksimalna: **37.63 N**. BMI pacijentica i iskustvo operatora statistički značajno koreliraju s primijenjenom silom. Ovi podaci daju inženjersike zahtjeve za robotske sustave.[^36]

***

## 9. Konceptualni i tehnički pregledi upravljačkih strategija (za sekciju 2. Metodologija)

### U1. MathWorks — Impedance Control Overview ⭐⭐⭐
Dostupno: [mathworks.com/...impedance-control.html](https://www.mathworks.com/company/technical-articles/enhancing-robot-precision-and-safety-with-impedance-control.html)

**Za intuitivno objašnjenje impedance control:** Regulacija interakcije robota s okolinom dinamičkim prilagođavanjem impedancije (stiffness + damping). Dobra za uvod u metodologiju.[^37]

***

### U2. Emergent Mind — Admittance Control ⭐⭐⭐
Dostupno: [emergentmind.com/topics/admittance-control](https://www.emergentmind.com/topics/admittance-control)

**Za matematički model:** Admittance controller transformira vanjsku silu u gibanje prema: \( M_d \ddot{x}(t) + B_d \dot{x}(t) + K_d x(t) = F_{ext}(t) \)[^38]

***

### U3. ScienceDirect Topics — Hybrid Position-Force Control ⭐⭐⭐
Dostupno: [sciencedirect.com/topics/engineering/hybrid-position-force-control](https://www.sciencedirect.com/topics/engineering/hybrid-position-force-control)

**Za definiciju i pregled hybrid control:** Dekuplingirana pozicija i sila u različitim podprostorima. Dobra referenca za metodološki uvod.[^39]

***

### U4. TUM — Unified Force-Impedance Control ⭐⭐⭐
Dostupno: [portal.fis.tum.de/en/publications/unified-force-impedance-control/](https://portal.fis.tum.de/en/publications/unified-force-impedance-control/)

**Za Varijantu C:** Integracija prednosti impedance i force control. Robustna kontakt/nekontakt stabilizacija — releventno za sigurnosnu analizu.[^40]

***

## 10. Strategija korištenja izvora u radu

### Preporučena raspodjela po sekcijama:

| Sekcija rada | Preporučeni izvori |
|---|---|
| **Abstract / Uvod** | S1, S2, S3 — motivacija, statistics |
| **Related Work** | S1–S5 (pregledi), K1 (klinički podaci) |
| **Osnove UZ + robotski sustavi (Var. A)** | S3, S4, K1 |
| **Upravljačke strategije — matematika** | A1, U1, U2, U3 + originalni radovi |
| **Force Control** | A1, A2, H1, H2, H3 |
| **Impedance Control** | I1, I2, I3 |
| **Admittance Control** | A1–A4, H2, H4 |
| **Hybrid Control** | H1–H4 |
| **Pregled konkretnih sustava (Var. B tablica)** | S1 (Tablica 2), S2 (Tablica 1), HaptiScan[^20], H2, H4 |
| **Image-guided control (Var. C)** | IG1–IG4 |
| **Learning-based (Var. C)** | L1–L3 |
| **Robustnost / respiracija (Var. C)** | M1, M2, A2 |
| **Sigurnost (Var. C)** | M3, S3 (safety section), U4 |
| **Rasprava** | S4 (gaps), S2 (bottlenecks) |

***

## 11. Preporučene baze za vlastitu pretragu

- **IEEE Xplore** (ieeexplore.ieee.org) — ključna baza, gotovo svi gore navedeni radovi
- **PubMed / PMC** — klinički radovi, open-access
- **arXiv** (cs.RO sekcija) — preprint radovi, slobodan pristup
- **ScienceDirect** (Elsevier) — Jiang et al. 2023 i drugi
- **MDPI** (open-access) — Sensors, Actuators, Robotics
- **Google Scholar** — za pronalazak PDF verzija

**Ključne pretraživačke fraze:**
- "robotic ultrasound force control"
- "admittance control ultrasound scanning"
- "impedance control ultrasound robot"
- "hybrid force position control ultrasound"
- "autonomous robotic ultrasound review"
- "contact force probe skin acoustic coupling"
- "force torque sensor robot ultrasound"

***

## 12. Napomene za pisanje rada

1. **Varijanta B** traži ≥ 3 konkretna robotska sustava — preporučeno iz Sekcije 4 ovog pregleda (tablica)
2. Obavezno uključiti **matematičke modele** svakog upravljačkog pristupa (admittance jednadžba, impedance jednadžba, hybrid matrix)
3. **Usporedna tablica upravljačkih pristupa** (prednosti/nedostaci/primjena) je ključna
4. Za svaki pristup objasniti **vezu sa specifičnim medicinskim zahtjevima** ultrazvučnog snimanja
5. Klinički podaci iz K1 (srednja sila 9.05 N) mogu se koristiti kao **referentne vrijednosti** za validaciju upravljačkih pristupa
6. **AI alati** su dopušteni ali se mora navesti kako su korišteni

---

## References

1. [Robotic Ultrasound Imaging: State-of-the-Art and Future Perspectives](https://arxiv.org/pdf/2307.05545.pdf) - Ultrasound (US) is one of the most widely used modalities for clinical
intervention and diagnosis du...

2. [A Review and Perspective of Techniques for Autonomous Robotic ...](https://pmc.ncbi.nlm.nih.gov/articles/PMC13074658/) - This system integrates robotic motion control with US imaging, demonstrating the feasibility of usin...

3. [Medical Robotics for Ultrasound Imaging: Current Systems and Future Trends](https://pmc.ncbi.nlm.nih.gov/articles/PMC7898497/) - Purpose of Review
This review provides an overview of the most recent robotic ultrasound systems tha...

4. [A Survey of Autonomous Robotic Ultrasound Scanning Systems](https://ieeexplore.ieee.org/document/11016698/) - This review investigates recent advancements in autonomous, semi-autonomous, and teleoperated roboti...

5. [A Survey of Autonomous Robotic Ultrasound Scanning Systems](https://ieeexplore.ieee.org/iel8/6287639/6514899/11016698.pdf) - ABSTRACT This review investigates recent advancements in autonomous, semi-autonomous, and teleoperat...

6. [A Review and Perspective of Techniques for Autonomous Robotic Ultrasound Acquisitions](https://www.mdpi.com/1424-8220/26/7/2081) - Ultrasound (US) imaging is a widely used diagnostic method in clinics. Real-time-generated US images...

7. [Force Tracking Control Method for Robotic Ultrasound Scanning System under Soft Uncertain Environment](https://www.mdpi.com/2076-0825/13/2/62) - Robotic ultrasound scanning has excellent potential to reduce physician workload, obtain higher-qual...

8. [Robot-Assisted Ultrasound Probe Force Control Under Respiration-Induced Motion](https://ieeexplore.ieee.org/document/10637095/) - A robot-assisted force control system for stable ultrasound imaging has been developed for abdomen i...

9. [[PDF] Interface Design and Control Strategies for a Robot Assisted ...](https://khatib.stanford.edu/publications/pdfs/Conti_2010_ISER.pdf) - A force controller maintains a constant contact force between the transducer and the patient's skin ...

10. [Admittance control for robotic-assisted tele-echography](http://ieeexplore.ieee.org/document/6766502/)

11. [Autonomous Ultrasound Scanning using Bayesian Optimization and Hybrid Force Control](https://ieeexplore.ieee.org/document/9812410/) - Ultrasound scanning is an imaging technique that aids medical professionals in diagnostics and inter...

12. [[PDF] Autonomous Ultrasound Scanning Using Bayesian Optimization and ...](http://biorobotics.ri.cmu.edu/papers/paperUploads/AutonomousUltrasoundScanning_Raghavv_Abhi.pdf) - surface and then combines it with a 6-axis hybrid force- position controller to perform autonomous s...

13. [Full-Coverage Path Planning and Stable Interaction Control for Automated Robotic Breast Ultrasound Scanning](https://ieeexplore.ieee.org/document/9889084/) - Ultrasound examination is widely used for diagnosis of breast cancer, which requires a full-coverage...

14. [A cascaded force/position hybrid control method based on ultrasound robots](https://ieeexplore.ieee.org/document/11277546/) - In the ultrasound robot automatic scanning, the robot needs to maintain a stable contact force in th...

15. [Robotic thyroid ultrasound scanning based on adaptive force/position hybrid control](https://iopscience.iop.org/article/10.1088/1742-6596/3240/1/012037) - To address the issues of unstable contact force and operator dependence in traditional thyroid ultra...

16. [Hybrid force/impedance control method for ultrasound robot based on three-dimensional modeling](https://ieeexplore.ieee.org/document/10136959/) - The ultrasound robot not only needs to be able to maintain stable contact forces in the direction of...

17. [Adaptive Speed-Regulated Impedance Control for Robotic ...](https://saemobilus.sae.org/papers/adaptive-speed-regulated-impedance-control-robotic-ultrasound-scanning-reducing-constant-force-tracking-errors-2026-99-0751) - Therefore, we propose an adaptive speed-regulated impedance control strategy to address this challen...

18. [Interactive Force-Impedance Control - arXiv](https://arxiv.org/html/2510.17341v1) - For the robot-assisted ultrasound scanning task, the target force was -3 N along the z z -direction....

19. [Robotic Ultrasound Scanning End-Effector with Adjustable Constant Contact Force](https://spj.science.org/doi/10.34133/cbsystems.0251) - In modern medical treatment, ultrasound scanning provides a radiation-free medical imaging method fo...

20. [HaptiScan: A Haptically-Enabled Robotic Ultrasound System for Remote Medical Diagnostics](https://www.mdpi.com/2218-6581/13/11/164) - Medical ultrasound is a widely used diagnostic imaging modality that provides real-time imaging at a...

21. [Autonomous robotic ultrasound scanning system: a key to enhancing image analysis reproducibility and observer consistency in ultrasound imaging](https://www.frontiersin.org/articles/10.3389/frobt.2025.1527686/full) - Purpose This study aims to develop an autonomous robotic ultrasound scanning system (auto-RUSS) pipe...

22. [Autonomous robotic ultrasound scanning system: a key to ... - PMC](https://pmc.ncbi.nlm.nih.gov/articles/PMC11835693/) - The force control algorithm is implemented through a Proportional-Derivative (PD) controller on the ...

23. [[PDF] Robotic Ultrasound Scanning with Real-Time Image-based Force ...](http://www.ece.ualberta.ca/~tbs/pmwiki/pdf/Frontiers-DDD-Akbari-2021.pdf) - algorithm into a teleoperation system to enable remote control of a US scanning robot. Here, the use...

24. [Comparison Between Force and Ultrasound Image-Based ...](https://research.utwente.nl/en/publications/comparison-between-force-andultrasound-image-based-controllers-fo/) - The force and hybrid controllers correct the probe contact based on the contact force of the end-eff...

25. [[PDF] Comparison Between Force and Ultrasound Image-Based ...](https://research.utwente.nl/files/501424076/978-3-031-76428-8_73.pdf) - Image feedback, uses confidence maps, to ensure acoustic coupling and optimize image quality. [1,4]....

26. [Smooth Path Planning and Dynamic Contact Force Regulation for Robotic Ultrasound Scanning](https://ieeexplore.ieee.org/document/11146611/) - The robotic breast ultrasound scanning (RBUS) system can help sonographer in the early screening of ...

27. [Explicit force-based control strategies for compliant robot-assisted ...](https://journals.sagepub.com/doi/abs/10.1177/02783649261441635) - Experimental results demonstrate that explicit force-based control improves ultrasound image quality...

28. [Inverse-Reinforcement-Learning-Based Robotic Ultrasound Active Compliance Control in Uncertain Environments](https://ieeexplore.ieee.org/document/10061438/) - Robotic ultrasound systems (RUSs) have gained increasing attention because they can automate repetit...

29. [Offline Reinforcement Learning-Based Adaptive Impedance Control for Variable Force Tracking in Robotic Ultrasound Scanning](https://ieeexplore.ieee.org/document/11377341/) - Robotic ultrasound scanning (RUSS) has become a promising solution to standardize ultrasound (US) ex...

30. [Autonomic Robotic Ultrasound Imaging System Based on Reinforcement Learning](https://ieeexplore.ieee.org/document/9336261/)

31. [Autonomic Robotic Ultrasound Imaging System Based on ... - PubMed](https://pubmed.ncbi.nlm.nih.gov/33497322/) - In this paper, we introduce an autonomous robotic ultrasound (US) imaging system based on reinforcem...

32. [Robotic Respiratory Liver Motion Compensation for Stable ...](https://ieeexplore.ieee.org/document/11131517/) - We employ a hybrid force-position control framework with an adaptive variable admittance controller ...

33. [Respiratory Motion-Robust Robotic Ultrasound Acquisitions via Vision-Haptic Fusion Control and 3-D Compensation](https://ieeexplore.ieee.org/document/11184711/) - Robotic 3-D ultrasound (US) has demonstrated potential for reliable organ volume acquisition. Howeve...

34. [Haptic Feedback for Telerobotic Ultrasound Procedures: Enhancing Safety Through Force Limiting](https://ieeexplore.ieee.org/document/11262065/) - The development of telerobotic systems for medical diagnostics has made it easier for people in remo...

35. [Path Generation and Stable Interaction Control for Autonomous Robotic Breast Ultrasound Scanning](https://ieeexplore.ieee.org/document/11482176/) - Ultrasound imaging is widely used for early breast tumor screening in clinical practice due to its o...

36. [Probe Contact Forces during Obstetric Ultrasound Scans](https://vbn.aau.dk/en/publications/probe-contact-forces-during-obstetric-ultrasound-scans-a-design-p/) - The study results provide design information about required contact forces for robotic solutions to ...

37. [Advanced Robotic Manipulation with Impedance Control - MathWorks](https://www.mathworks.com/company/technical-articles/enhancing-robot-precision-and-safety-with-impedance-control.html) - Impedance control is an advanced methodology that allows robots to emulate the compliant behavior ch...

38. [Admittance Control in Robotics - Emergent Mind](https://www.emergentmind.com/topics/admittance-control) - Admittance control is a model-based methodology that translates external forces into motion using a ...

39. [Hybrid Position-Force Control - an overview | ScienceDirect Topics](https://www.sciencedirect.com/topics/engineering/hybrid-position-force-control) - Hybrid force/position control refers to control approaches that manage both position and force in ro...

40. [Unified force-impedance control - Technical University of Munich](https://portal.fis.tum.de/en/publications/unified-force-impedance-control/) - Unified force-impedance control (UFIC) aims at integrating the advantages of impedance control and f...


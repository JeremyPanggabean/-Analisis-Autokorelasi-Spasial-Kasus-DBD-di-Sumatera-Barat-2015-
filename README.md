# 🦟 Analisis Autokorelasi Spasial Kasus DBD di Sumatera Barat (2015)

Proyek ini bertujuan untuk menganalisis **pola spasial** dari jumlah kasus **Demam Berdarah Dengue (DBD)** di wilayah **Sumatera Barat** pada tahun **2015**. Dengan menggunakan teknik **autokorelasi spasial global dan lokal**, analisis ini mengeksplorasi apakah distribusi kasus DBD menunjukkan pola klaster atau penyebaran acak di antara kecamatan.

## 📦 Dataset

- **data DBD Sumbar 2015.csv**  
  Berisi jumlah kasus DBD per kecamatan di Sumatera Barat tahun 2015 serta koordinat geografis (longitude & latitude).
- **Shapefile Kecamatan Sumatera Barat** (`.shp`, `.shx`, `.dbf`, dll.)  
  Digunakan untuk pemetaan spasial (polygon tiap kecamatan).

## 🛠️ Tools & Package yang Digunakan

- `R` & `RStudio`
- `sf` – untuk data spasial/shapefile
- `spdep` – untuk analisis autokorelasi spasial
- `ggplot2` – untuk visualisasi
- `dplyr`, `gridExtra`, `readr` – manipulasi data

## 🔍 Metodologi

### 1. Preprocessing Data

- Import dataset kasus DBD dan shapefile.
- Konversi koordinat & cleaning data.

### 2. Pembuatan Matriks Pembobot Spasial

- Tiga jenis pembobot yang diuji:
  - **Jarak Invers** (`1/distance`)
  - **K-Nearest Neighbors (KNN)**
  - **Queen Contiguity** (berdasarkan batas spasial polygon)

### 3. Autokorelasi Spasial Global

- **Moran's I Global**
- **Geary's C Global**

### 4. Autokorelasi Spasial Lokal (Local Indicators of Spatial Association)

- Menghitung nilai **Local Moran’s I**
- Menstandarisasi nilai kasus DBD dan menghitung **lag spasial**
- Mengkategorikan ke dalam 4 kuadran:
  - `High-High`
  - `Low-Low`
  - `High-Low`
  - `Low-High`

## 🗺️ Analisis Spasial Kasus DBD di Sumatera Barat

### 🔍 Moran Scatterplot

![Moran Scatterplot](Moran%20Scatterplot.png)

Scatterplot ini menunjukkan hubungan antara nilai atribut (jumlah kasus DBD) pada suatu kecamatan (`x1`) dengan rata-rata spasial tetangganya (`spatially lagged x1`). Titik-titik yang ditandai (berlian) adalah kecamatan dengan _Local Moran's I_ yang signifikan (`p-value < 0.05`), yang kemudian diklasifikasikan ke dalam empat kuadran:

- **Kuadran I (High-High)**: Nilai tinggi dikelilingi nilai tinggi → potensi klaster penyakit.
- **Kuadran II (Low-High)**: Nilai rendah dikelilingi nilai tinggi → kemungkinan outlier.
- **Kuadran III (Low-Low)**: Nilai rendah dikelilingi nilai rendah → stabil dan relatif aman.
- **Kuadran IV (High-Low)**: Nilai tinggi dikelilingi nilai rendah → potensi outlier.

---

### 🗺️ Peta Kuadran Local Moran

![Peta Kuadran Local Moran](Peta%20Kuadran%20Local%20Moran.png)

Peta ini memvisualisasikan kategori kuadran berdasarkan hasil _Local Moran's I_ untuk setiap kecamatan di Sumatera Barat. Warna menunjukkan pola spasial:

- 🟥 **High-High**: Wilayah rawan dengan konsentrasi tinggi kasus DBD.
- 🟧 **High-Low**: Outlier – wilayah dengan kasus tinggi di antara tetangga yang rendah.
- 🟦 **Low-High**: Outlier – wilayah dengan kasus rendah di antara tetangga yang tinggi.
- 🟩 **Low-Low**: Wilayah aman dengan kasus rendah secara konsisten.

---

### 🧪 Signifikansi Autokorelasi Spasial

![Signifikansi Autokorelasi Spasial](Visualisasi%20Signifikansi%20Autokorelasi%20Spasial.png)

Peta ini menyoroti kecamatan dengan _autokorelasi spasial signifikan_ berdasarkan uji _Local Moran_ (`p-value < 0.05`):

- 🔴 **Signifikan**: Ada pola spasial yang kuat – wilayah ini layak jadi prioritas analisis atau intervensi.
- ⚪ **Tidak Signifikan**: Tidak ada indikasi pola spasial yang kuat – kemungkinan penyebaran acak atau tidak stabil.

---

## 🧠 Insight dan Implikasi Kebijakan

1. **Identifikasi Klaster**  
   Wilayah `High-High` perlu menjadi prioritas dalam kebijakan intervensi, karena mengindikasikan adanya klaster penyebaran DBD yang signifikan secara geografis.

2. **Manajemen Risiko di Outlier**  
   Wilayah `High-Low` dan `Low-High` mungkin menunjukkan dinamika lokal unik seperti:

   - Perbedaan dalam pelaporan data.
   - Faktor lingkungan atau sosial tertentu.
   - Keberhasilan/kegagalan kebijakan lokal.

   Wilayah ini perlu analisis mendalam sebelum pengambilan keputusan.

3. **Validasi dengan Signifikansi**  
   Tidak semua pola spasial bermakna. Oleh karena itu, peta signifikansi membantu menyaring wilayah dengan pola spasial yang _statistically valid_ untuk dijadikan dasar dalam kebijakan berbasis lokasi (_evidence-based spatial planning_).

4. **Arah Strategis**
   - Gunakan hasil ini untuk menyusun program _early warning system_ berbasis spasial.
   - Alokasikan sumber daya secara lebih efisien ke wilayah dengan pola penyebaran DBD yang terbukti signifikan.

---

## ▶️ Replikasi Analisis

1. Clone repositori ini
   ```bash
   git clone https://github.com/username/Autokorelasi Spasial Latihan.git
   ```
2. Buka file atau script utama di `Rstudio`

3. Install packages pada file `Requirements.txt`

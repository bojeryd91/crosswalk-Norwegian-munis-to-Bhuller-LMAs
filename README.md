# Crosswalk: Norwegian municipalities to Bhuller (2009) labor market regions

This repository maps Norwegian municipality (*kommune*) codes from every
classification vintage between 1995 and 2024 onto the 46 labor market regions
(*arbeidsmarkedsregioner*, LMAs) defined by Bhuller (2009).

Bhuller defines the regions on the 2008 municipality classification. Because
municipalities have since been renumbered, merged and split, a 2008-based
region assignment cannot be applied directly to data coded with a different
vintage. This repository therefore does two things:

1. It builds crosswalks between consecutive vintages of SSB's municipality
   classification (Klass 131), recording the type of every change.
2. It carries the 2008 region assignment through those crosswalks, so each
   vintage's codes have an LMA.

## Files

| File | Contents | Unique on |
|---|---|---|
| `muni_to_Bhuller_LMAs.dta` | The 430 municipalities of 2008 and their LMA, as in Bhuller (2009) | `muni_code_2008` |
| `crosswalks/muni_code_multiple_vintages.dta` | Wide crosswalk: one row per path from a 1995 code to a 2024 code, with codes, change types and LMAs for every vintage | no single code variable (see below) |
| `crosswalks/muni_code_vintages_<old>_to_<new>.dta` | Pairwise crosswalk between two consecutive vintages, with the LMA of the new vintage | `muni_code_<old>`, except for split municipalities |
| `csv/*.csv` | CSV copies of all of the above | as above |

Code:

| File | Purpose |
|---|---|
| `A0_main.do` | Runs A1 and A2 in order; rebuilds every output |
| `A1_define_labor_market_regions.do` | Assigns each 2008 municipality to its Bhuller (2009) LMA |
| `A2_create_muni_code_vintages_crosswalks.do` | Builds the vintage crosswalks, carries the LMAs through them, and exports CSVs |

## Vintages

A vintage is identified by the year its codes took effect (1 January). Use the
vintage in force in the year your data refer to:

| Vintage | In force | Vintage | In force |
|---|---|---|---|
| 1995 | 1995–2001 | 2013 | 2013–2016 |
| 2002 | 2002–2004 | 2017 | 2017 |
| 2005 | 2005 | 2018 | 2018 |
| 2006 | 2006–2007 | 2019 | 2019 |
| 2008 | 2008–2011 | 2020 | 2020–2023 |
| 2012 | 2012 | 2024 | 2024– |

Years without their own vintage (2003, 2004, 2011, 2015, 2022, 2023) changed
only municipality names or spellings, not codes.

## Variables

| Variable | Description |
|---|---|
| `muni_code_<year>` | Four-digit municipality code in vintage `<year>`, stored as a string with leading zeros |
| `muni_name_1995` | Municipality name in the 1995 vintage (names are carried for 1995 only; later names are available from [SSB Klass](https://www.ssb.no/klass/klassifikasjoner/131)) |
| `change_type_<old>_<new>` | How the municipality changed between the two vintages (codes below) |
| `arbmarkregion_<year>` | Bhuller (2009) LMA of the municipality with code `muni_code_<year>` |
| `arbmarkregion` | LMA (in `muni_to_Bhuller_LMAs.dta` only) |

`change_type_<old>_<new>` codes:

| Code | Meaning |
|---|---|
| 0 | No change |
| 1 | Renumbering (new code, same territory) |
| 2 | Merger |
| 3 | Split |
| 4 | Split and merger (a municipality divided between neighbours that were themselves merging) |

The `.dta` files carry these as value labels. The CSV files store the numeric
codes only.

## Using the crosswalk

### Attaching LMAs to data coded in any vintage

Each municipality code maps to exactly one LMA within its vintage, so the
recipe is the same for every year:

```stata
* LMA lookup for codes in the 2013 vintage (data from 2013–2016)
use "crosswalks/muni_code_multiple_vintages", clear
keep muni_code_2013 arbmarkregion_2013
duplicates drop
isid muni_code_2013
tempfile lma2013
save `lma2013'

use "mydata", clear                 // contains muni_code_2013
merge m:1 muni_code_2013 using `lma2013'
```

### Converting codes between vintages: splits are one-to-many

Mergers are many-to-one and cause no ambiguity when moving forward in time.
**Splits are one-to-many:** a split municipality appears once for each
municipality it was divided between. As a result:

- the pairwise files are not unique on `muni_code_<old>` in the three
  vintages with a split;
- the wide file has 444 rows, more than any single vintage has municipalities.

The split municipalities are:

| Vintage step | Old municipality | Divided between |
|---|---|---|
| 2013 → 2017 | 0720 Stokke | 0704 Tønsberg, 0710 Sandefjord |
| 2019 → 2020 | 1850 Tysfjord | 1806 Narvik, 1875 Hábmer – Hamarøy |
| 2019 → 2020 | 5012 Snillfjord | 5055 Heim, 5056 Hitra, 5059 Orkland |
| 2020 → 2024 | 1507 Ålesund | 1508 Ålesund, 1580 Haram |

The crosswalk carries no population or area weights for the branches of a
split. A `merge m:1` on `muni_code_<old>` against a split vintage will
therefore fail. To convert codes forward, decide how to treat these
municipalities first. For example, keep one branch per split, or use
`joinby` and apply your own weights.

### Reading the CSV files

Municipality codes have leading zeros (e.g. `0301` for Oslo). Read the
`muni_code_*` columns as text, e.g. `pd.read_csv(f, dtype=str)` in Python or
`readr::read_csv(f, col_types = cols(.default = "c"))` in R.

## Hand-assigned LMAs after mergers across region borders

Bhuller's regions are defined for 2008. When a later merger combined
municipalities from different regions, the new municipality is assigned one
LMA by hand in `A2_create_muni_code_vintages_crosswalks.do`. The rule is to
use the LMA of the constituent part with the larger 2007 population. Where
only part of a municipality joined, the LMA of the municipality that merged
in full is used.

| New municipality (vintage) | Constituent municipalities (LMA) | Assigned LMA |
|---|---|---|
| 1756 Inderøy (2012) | 1723 Mosvik (61), 1729 Inderøy (62) | 62 |
| 1577 Volda (2020) | 1444 Hornindal (53), 1519 Volda (54) | 54 |
| 1875 Hábmer – Hamarøy (2020) | 1849 Hamarøy (71), part of 1850 Tysfjord (72) | 71 |
| 3802 Holmestrand (2020) | 0713 Sande (12), 0715 Holmestrand (13) | 12 |
| 4225 Lyngdal (2020) | 1027 Audnedal (35), 1032 Lyngdal (36) | 36 |
| 4602 Kinn (2020) | 1401 Flora (51), 1439 Vågsøy (53) | 51 |
| 4640 Sogndal (2020) | 1418 Balestrand (51), 1419 Leikanger (52), 1420 Sogndal (52) | 52 |
| 5007 Namsos (2020) | 1725 Namdalseid (62), 1703 Namsos (63), 1748 Fosnes (63) | 63 |
| 5055 Heim (2020) | 1571 Halsa (57), 5011 Hemne (61), part of 5012 Snillfjord (61) | 61 |
| 5412 Tjeldsund (2020) | 1852 Tjeldsund (72), 1913 Skånland (75) | 75 |

These assignments carry over to the same municipality's codes in later
vintages (e.g. Holmestrand's 2024 code). Users who prefer a different rule can
change the corresponding lines in A2 and rerun `A0_main.do`. The script checks
that no other merger produces a municipality with more than one LMA.

## Reproducing the outputs

From the repository root, run:

```stata
do A0_main.do
```

No user-written Stata packages are required. The scripts stop with an error if:

- a municipality code would map to more than one LMA within a vintage, or
- a pairwise crosswalk is non-unique on the old code outside the known splits.

## Sources

- Bhuller, M. S. (2009). *Inndeling av Norge i arbeidsmarkedsregioner*.
  Notater 2009/24, Statistisk sentralbyrå.
  <https://www.ssb.no/arbeid-og-lonn/artikler-og-publikasjoner/inndeling-av-norge-i-arbeidsmarkedsregioner>
- Statistics Norway, SSB Klass classification 131, *Standard for
  kommuneinndeling*: <https://www.ssb.no/klass/klassifikasjoner/131>. The
  change page for every vintage step is linked in A2.

## License

- Code (`.do` files): MIT, see [LICENSE](LICENSE).
- Data (`.dta` and `.csv` files): CC BY 4.0, see
  [LICENSE-DATA.md](LICENSE-DATA.md). The source material is published by
  Statistics Norway under CC BY 4.0.

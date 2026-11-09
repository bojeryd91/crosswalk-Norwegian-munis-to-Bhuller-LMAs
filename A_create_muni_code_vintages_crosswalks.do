
/*
	Crosswalks between vintages of the Norwegian municipality (kommune)
	classification, SSB Klass classification 131. Starts from
	Kommuneinndeling 1995 (SSB Klass version 2753 -- 435 municipalities),
	carrying the 1995 name alongside the code, then builds one crosswalk
	per later vintage that had a code change:

		1995 -> 2002 -> 2005 -> 2006 -> 2008 -> 2012 -> 2013 -> 2017
		     -> 2018 -> 2019 -> 2020 -> 2024

	Vintages in between (2003, 2004, 2011, 2015, 2022, 2023) had only
	spelling / name changes, no code change, and are skipped.

	For each consecutive pair the script takes the previous vintage's
	codes, copies them forward, and applies that vintage's changes
	(renumberings, mergers, splits) from the SSB Klass "endringer" page
	for the relevant classification version -- the URL is given in each
	block. Each pair is saved to
	crosswalks/muni_code_vintages_<old>_to_<new>.dta with a
	change_type_<old>_<new> variable (see the change_types label below).
	The pairwise files are then chained into one wide crosswalk,
	crosswalks/muni_code_multiple_vintages.dta, onto which the Bhuller
	(2009) labor-market regions are merged.
*/

*** Value label for the change_type_<old>_<new> variable added to every
*** crosswalk below -- defined once here, reused throughout
label define change_types 0 "No change" 1 "Renumbering" 2 "Merger" ///
							3 "Split" 4 "Split and merger"

******************************************************************************
*** Create 1995 vintage of the municipality categorizations

clear
#delimit ;
input str4 muni_code_1995 str40 muni_name_1995;
"0101" "Halden";	"0104" "Moss";		"0105" "Sarpsborg";	"0106" "Fredrikstad";
"0111" "Hvaler";	"0118" "Aremark";	"0119" "Marker";	"0121" "Rømskog";
"0122" "Trøgstad";	"0123" "Spydeberg";	"0124" "Askim";		"0125" "Eidsberg";
"0127" "Skiptvet";	"0128" "Rakkestad";	"0135" "Råde";		"0136" "Rygge";
"0137" "Våler (Østfold)";              	"0138" "Hobøl";		"0211" "Vestby";
"0213" "Ski";		"0214" "Ås";        "0215" "Frogn";		"0216" "Nesodden";
"0217" "Oppegård";	"0219" "Bærum";     "0220" "Asker";
"0221" "Aurskog-Høland";               	"0226" "Sørum";		"0227" "Fet";
"0228" "Rælingen";	"0229" "Enebakk";   "0230" "Lørenskog";	"0231" "Skedsmo";
"0233" "Nittedal";	"0234" "Gjerdrum";  "0235" "Ullensaker";
"0236" "Nes (Akershus)";               	"0237" "Eidsvoll";	"0238" "Nannestad";
"0239" "Hurdal";	"0301" "Oslo";      "0402" "Kongsvinger";
"0403" "Hamar";		"0412" "Ringsaker"; "0415" "Løten";		"0417" "Stange";
"0418" "Nord-Odal"; "0419" "Sør-Odal";	"0420" "Eidskog";	"0423" "Grue";
"0425" "Åsnes";     "0426" "Våler (Hedmark)";				"0427" "Elverum";
"0428" "Trysil";    "0429" "Åmot";		"0430" "Stor-Elvdal";
"0432" "Rendalen";	"0434" "Engerdal";  "0436" "Tolga";		"0437" "Tynset";
"0438" "Alvdal";	"0439" "Folldal";   "0441" "Os (Hedmark)";
"0501" "Lillehammer";                  	"0502" "Gjøvik";	"0511" "Dovre";
"0512" "Lesja";		"0513" "Skjåk";     "0514" "Lom";		"0515" "Vågå";
"0516" "Nord-Fron";	"0517" "Sel";		"0519" "Sør-Fron";	"0520" "Ringebu";
"0521" "Øyer";		"0522" "Gausdal";	"0528" "Østre Toten";
"0529" "Vestre Toten";					"0532" "Jevnaker";	"0533" "Lunner";
"0534" "Gran";		"0536" "Søndre Land";					"0538" "Nordre Land";
"0540" "Sør-Aurdal";					"0541" "Etnedal";	"0542" "Nord-Aurdal";
"0543" "Vestre Slidre";					"0544" "Øystre Slidre";
"0545" "Vang (Oppland)";				"0602" "Drammen";	"0604" "Kongsberg";
"0605" "Ringerike";	"0612" "Hole";		"0615" "Flå (Buskerud)";
"0616" "Nes (Buskerud)";				"0617" "Gol";		"0618" "Hemsedal";
"0619" "Ål";		"0620" "Hol (Buskerud)";				"0621" "Sigdal";
"0622" "Krødsherad";"0623" "Modum";		"0624" "Øvre Eiker";"0625" "Nedre Eiker";
"0626" "Lier";		"0627" "Røyken";	"0628" "Hurum";		"0631" "Flesberg";
"0632" "Rollag";	"0633" "Nore og Uvdal";					"0701" "Borre";
"0702" "Holmestrand";					"0704" "Tønsberg";	"0706" "Sandefjord";
"0709" "Larvik";	"0711" "Svelvik";	"0713" "Sande (Vestfold)";
"0714" "Hof (Vestfold)";				"0716" "Våle";		"0718" "Ramnes";
"0719" "Andebu";	"0720" "Stokke";	"0722" "Nøtterøy";	"0723" "Tjøme";
"0728" "Lardal";	"0805" "Porsgrunn";	"0806" "Skien";		"0807" "Notodden";
"0811" "Siljan";	"0814" "Bamble";	"0815" "Kragerø";	"0817" "Drangedal";
"0819" "Nome";		"0821" "Bø (Telemark)";					"0822" "Sauherad";
"0826" "Tinn";		"0827" "Hjartdal";	"0828" "Seljord";	"0829" "Kviteseid";
"0830" "Nissedal";	"0831" "Fyresdal";	"0833" "Tokke";		"0834" "Vinje";
"0901" "Risør";		"0904" "Grimstad";	"0906" "Arendal";	"0911" "Gjerstad";
"0912" "Vegårshei";	"0914" "Tvedestrand";					"0919" "Froland";
"0926" "Lillesand";	"0928" "Birkenes";	"0929" "Åmli";		"0935" "Iveland";
"0937" "Evje og Hornnes";				"0938" "Bygland";	"0940" "Valle";
"0941" "Bykle";		"1001" "Kristiansand";					"1002" "Mandal";
"1003" "Farsund";	"1004" "Flekkefjord";					"1014" "Vennesla";
"1017" "Songdalen";	"1018" "Søgne";		"1021" "Marnardal";	"1026" "Åseral";
"1027" "Audnedal";	"1029" "Lindesnes";	"1032" "Lyngdal";	"1034" "Hægebostad";
"1037" "Kvinesdal";	"1046" "Sirdal";	"1101" "Eigersund";	"1102" "Sandnes";
"1103" "Stavanger";	"1106" "Haugesund";	"1111" "Sokndal";	"1112" "Lund";
"1114" "Bjerkreim";	"1119" "Hå";		"1120" "Klepp";		"1121" "Time";
"1122" "Gjesdal";	"1124" "Sola";		"1127" "Randaberg";	"1129" "Forsand";
"1130" "Strand";	"1133" "Hjelmeland";"1134" "Suldal";	"1135" "Sauda";
"1141" "Finnøy";	"1142" "Rennesøy";	"1144" "Kvitsøy";	"1145" "Bokn";
"1146" "Tysvær";	"1149" "Karmøy";	"1151" "Utsira";	"1154" "Vindafjord";
"1201" "Bergen";	"1211" "Etne";		"1214" "Ølen";		"1216" "Sveio";
"1219" "Bømlo";		"1221" "Stord";		"1222" "Fitjar";	"1223" "Tysnes";
"1224" "Kvinnherad";"1227" "Jondal";	"1228" "Odda";		"1231" "Ullensvang";
"1232" "Eidfjord";	"1233" "Ulvik";		"1234" "Granvin";	"1235" "Voss";
"1238" "Kvam";		"1241" "Fusa";		"1242" "Samnanger";
"1243" "Os (Hordaland)";				"1244" "Austevoll";	"1245" "Sund";
"1246" "Fjell";		"1247" "Askøy";		"1251" "Vaksdal";	"1252" "Modalen";
"1253" "Osterøy";	"1256" "Meland";	"1259" "Øygarden";	"1260" "Radøy";
"1263" "Lindås";	"1264" "Austrheim";	"1265" "Fedje";		"1266" "Masfjorden";
"1401" "Flora";		"1411" "Gulen";		"1412" "Solund";	"1413" "Hyllestad";
"1416" "Høyanger";	"1417" "Vik";		"1418" "Balestrand";"1419" "Leikanger";
"1420" "Sogndal (Sogn og Fjordane)";	"1421" "Aurland";	"1422" "Lærdal";
"1424" "Årdal (Sogn og Fjordane)";		"1426" "Luster";	"1428" "Askvoll";
"1429" "Fjaler";	"1430" "Gaular";	"1431" "Jølster";	"1432" "Førde";
"1433" "Naustdal";	"1438" "Bremanger";	"1439" "Vågsøy";	"1441" "Selje";
"1443" "Eid (Sogn og Fjordane)";		"1444" "Hornindal";	"1445" "Gloppen";
"1449" "Stryn";		"1502" "Molde";		"1503" "Kristiansund";
"1504" "Ålesund";	"1511" "Vanylven";	"1514" "Sande (Møre og Romsdal)";
"1515" "Herøy (Møre og Romsdal)";		"1516" "Ulstein";	"1517" "Hareid";
"1519" "Volda";		"1520" "Ørsta";		"1523" "Ørskog";	"1524" "Norddal";
"1525" "Stranda";	"1526" "Stordal";	"1528" "Sykkylven";	"1529" "Skodje";
"1531" "Sula";		"1532" "Giske";		"1534" "Haram";		"1535" "Vestnes";
"1539" "Rauma";		"1543" "Nesset";	"1545" "Midsund";	"1546" "Sandøy";
"1547" "Aukra";		"1548" "Fræna";		"1551" "Eide (Møre og Romsdal)";
"1554" "Averøy";	"1556" "Frei";		"1557" "Gjemnes";	"1560" "Tingvoll";
"1563" "Sunndal";	"1566" "Surnadal";	"1567" "Rindal";	"1569" "Aure";
"1571" "Halsa";		"1572" "Tustna";	"1573" "Smøla";		"1601" "Trondheim";
"1612" "Hemne";		"1613" "Snillfjord";"1617" "Hitra";		"1620" "Frøya";
"1621" "Ørland";	"1622" "Agdenes";	"1624" "Rissa";		"1627" "Bjugn";
"1630" "Åfjord";	"1632" "Roan";		"1633" "Osen";		"1634" "Oppdal";
"1635" "Rennebu";	"1636" "Meldal";	"1638" "Orkdal";	"1640" "Røros";
"1644" "Holtålen";	"1648" "Midtre Gauldal";				"1653" "Melhus";
"1657" "Skaun";		"1662" "Klæbu";		"1663" "Malvik";	"1664" "Selbu";
"1665" "Tydal";		"1702" "Steinkjer";	"1703" "Namsos";	"1711" "Meråker";
"1714" "Stjørdal";	"1717" "Frosta";	"1718" "Leksvik";	"1719" "Levanger";
"1721" "Verdal";	"1723" "Mosvik";	"1724" "Verran";	"1725" "Namdalseid";
"1729" "Inderøy";	"1736" "Snåsa";		"1738" "Lierne";	"1739" "Røyrvik";
"1740" "Namsskogan";"1742" "Grong";		"1743" "Høylandet";	"1744" "Overhalla";
"1748" "Fosnes";	"1749" "Flatanger";	"1750" "Vikna";		"1751" "Nærøy";
"1755" "Leka";		"1804" "Bodø";		"1805" "Narvik";	"1811" "Bindal";
"1812" "Sømna";		"1813" "Brønnøy";	"1815" "Vega";		"1816" "Vevelstad";
"1818" "Herøy (Nordland)";				"1820" "Alstahaug";	"1822" "Leirfjord";
"1824" "Vefsn";		"1825" "Grane";		"1826" "Hattfjelldal";
"1827" "Dønna";		"1828" "Nesna";		"1832" "Hemnes";	"1833" "Rana";
"1834" "Lurøy";		"1835" "Træna";		"1836" "Rødøy";		"1837" "Meløy";
"1838" "Gildeskål";	"1839" "Beiarn";	"1840" "Saltdal";	"1841" "Fauske";
"1842" "Skjerstad";	"1845" "Sørfold";	"1848" "Steigen";	"1849" "Hamarøy";
"1850" "Tysfjord";	"1851" "Lødingen";	"1852" "Tjeldsund";	"1853" "Evenes";
"1854" "Ballangen";	"1856" "Røst";		"1857" "Værøy";		"1859" "Flakstad";
"1860" "Vestvågøy";	"1865" "Vågan";		"1866" "Hadsel";	"1867" "Bø (Nordland)";
"1868" "Øksnes";	"1870" "Sortland";	"1871" "Andøy";		"1874" "Moskenes";
"1901" "Harstad";	"1902" "Tromsø";	"1911" "Kvæfjord";	"1913" "Skånland";
"1915" "Bjarkøy";	"1917" "Ibestad";	"1919" "Gratangen";	"1920" "Lavangen";
"1922" "Bardu";		"1923" "Salangen";	"1924" "Målselv";	"1925" "Sørreisa";
"1926" "Dyrøy";		"1927" "Tranøy";	"1928" "Torsken";	"1929" "Berg (Troms)";
"1931" "Lenvik";	"1933" "Balsfjord";	"1936" "Karlsøy";	"1938" "Lyngen";
"1939" "Storfjord";	"1940" "Gáivuotna - Kåfjord";			"1941" "Skjervøy";
"1942" "Nordreisa";	"1943" "Kvænangen";	"2002" "Vardø";		"2003" "Vadsø";
"2004" "Hammerfest";"2011" "Guovdageaidnu - Kautokeino";	"2012" "Alta";
"2014" "Loppa";		"2015" "Hasvik";	"2017" "Kvalsund";	"2018" "Måsøy";
"2019" "Nordkapp";	"2020" "Porsanger"; "2021" "Kárášjohka - Karasjok";
"2022" "Lebesby"; 	"2023" "Gamvik";	"2024" "Berlevåg";	"2025" "Deatnu - Tana";
"2027" "Unjárga - Nesseby";				"2028" "Båtsfjord";	"2030" "Sør-Varanger";
end;
#delimit cr

******************************************************************************
*** Add crosswalk to 2002
*	As in https://www.ssb.no/klass/klassifikasjoner/131/versjon/479/endringer

*** By default, the 2002 code equals the 1995 code
gen str4 muni_code_2002 = muni_code_1995

*** Apply the 1995-to-2002 Re merger: Vale (0716) and Ramnes (0718) merged
*** into the new Re, which kept code 0716
replace muni_code_2002 = "0716"    if inlist(muni_code_1995, "0716", "0718")
gen byte change_type_1995_2002 = 2 if inlist(muni_code_1995, "0716", "0718")

*** Apply the 1995-to-2002 Olen renumbering: Olen moved from Hordaland
*** numbering (1214) to Rogaland numbering (1159); pure renumbering, no
*** boundary change
replace muni_code_2002 = "1159"   if muni_code_1995 == "1214"
replace change_type_1995_2002 = 1 if muni_code_1995 == "1214"

replace change_type_1995_2002 = 0 if muni_code_2002 == muni_code_1995 & ///
													change_type_1995_2002 == .
count if change_type_1995_2002 == .													
													
label values change_type_1995_2002 change_types

save "crosswalks/muni_code_vintages_1995_to_2002", replace

******************************************************************************
*** Create crosswalk between consecutive vintages

use "crosswalks/muni_code_vintages_1995_to_2002", clear

foreach vintage in 2002_to_2005 2005_to_2006 2006_to_2008 2008_to_2012 ///
					2012_to_2013 2013_to_2017 2017_to_2018 2018_to_2019 ///
												2019_to_2020 2020_to_2024 {
	local old_y = substr("`vintage'", 1, 4)
	local new_y = substr("`vintage'", 9, 4)
	
	disp "Working on crosswalk `old_y' to `new_y'"
	
	keep muni_code_`old_y'
	qui duplicates drop
	
	*** By default, the new code equals the old code
	rename muni_code_`old_y' old
	gen str4 new = old
	gen byte change_type = .
	
	*** Apply this vintage's changes
	qui {
	if "`vintage'" == "2002_to_2005" { // 2003 & 2004 skipped, only spelling
		* Apply changes as in
		* https://www.ssb.no/klass/klassifikasjoner/131/versjon/477/endringer
		
		*	Bodo (1804) incorporated Skjerstad (1842)
		replace new = "1804"    if old == "1842"
		replace change_type = 2 if new == "1804"
	}
	else if "`vintage'" == "2005_to_2006" {
		* Apply changes as in
		* https://www.ssb.no/klass/klassifikasjoner/131/versjon/476/endringer
		
		*	Vindafjord (1160) was created by merging Vindafjord (1154) and
		*	Olen (1159)
		replace new = "1160"    if inlist(old, "1154", "1159")
		replace change_type = 2 if new == "1160"
		*	Aure (1576) was created by merging Aure (1569) and Tustna (1572)
		replace new = "1576"    if inlist(old, "1569", "1572")
		replace change_type = 2 if new == "1576"
	}
	else if "`vintage'" == "2006_to_2008" {
		* Apply changes as in
		* https://www.ssb.no/klass/klassifikasjoner/131/versjon/475/endringer
		*	Kristiansund (1505) was created by merging Kristiansund (1503) and
		*	Frei (1556)
		replace new = "1505"    if inlist(old, "1503", "1556")
		replace change_type = 2 if new == "1505"
	}
	else if "`vintage'" == "2008_to_2012" { // 2011 skipped, only spelling
		* Apply changes as in
		* https://www.ssb.no/klass/klassifikasjoner/131/versjon/474/endringer
		*	Inderoy (1756) was created by merging Mosvik (1723) and Inderoy
		*	(1729)
		replace new = "1756"    if inlist(old, "1723", "1729")
		replace change_type = 2 if new == "1756"
	}
	else if "`vintage'" == "2012_to_2013" {
		* Apply changes as in
		* https://www.ssb.no/klass/klassifikasjoner/131/versjon/473/endringer
		*	Harstad (1903) was created by merging Harstad (1901) and Bjarkoy
		*	(1915)
		replace new = "1903"    if inlist(old, "1901", "1915")
		replace change_type = 2 if new == "1903"
	}
	else if "`vintage'" == "2013_to_2017" { // 2015 skipped, only spelling
		* Apply changes as in
		* https://www.ssb.no/klass/klassifikasjoner/131/versjon/536/endringer
		
		*** Municipality splits
		*	Stokke (0720) was split between Tønsberg (0704) and
		*	Sandefjord (0710).
		expand 2 if old == "0720"

		bysort old: gen idx = _n

		*	(0720) -> (0704) and (0710)
		replace new = "0704"    if old == "0720" & idx == 1
		replace new = "0710"	if old == "0720" & idx == 2
		replace change_type = 4 if old == "0720"
		
		drop idx

		*** Municipality mergers

		*	Tonsberg (0704) incorporated a part of Stokke (0720), treated above
		replace change_type = 2 if new == "0704" & change_type == .

		*	Sandefjord (0710) was created by merging Sandefjord (0706),
		*	Andebu (0719), and a part of Stokke (0720), treated above
		replace new = "0710"    if inlist(old, "0706", "0719")
		replace change_type = 2 if new == "0710" & change_type == .
	}
	else if "`vintage'" == "2017_to_2018" {
		* Apply changes as in
		* https://www.ssb.no/klass/klassifikasjoner/131/versjon/833/endringer
		
		*** Pure renumbering: the 2018 creation of Trondelag county (merger of
		*	Sor-Trondelag and Nord-Trondelag) renumbered every municipality in
		*	those two counties from a 16xx/17xx code to a new 50xx code, with
		*	no boundary or name change. Verified against SSB Klass
		*	classification 131, version 833.
		#delimit ;
		local old_2017_2018	1601 1702 1703 1612 1613 1617 1620
							1621 1622 1627 1630 1632 1633 1634
							1635 1636 1638 1640 1644 1648 1653
							1657 1662 1663 1664 1665 1711 1714
							1717 1719 1721 1724 1725 1736 1738
							1739 1740 1742 1743 1744 1748 1749
							1750 1751 1755 1756;
		local new_2017_2018	5001 5004 5005 5011 5012 5013 5014
							5015 5016 5017 5018 5019 5020 5021
							5022 5023 5024 5025 5026 5027 5028
							5029 5030 5031 5032 5033 5034 5035
							5036 5037 5038 5039 5040 5041 5042
							5043 5044 5045 5046 5047 5048 5049
							5050 5051 5052 5053;
		#delimit cr
		local n_2017_2018 : word count `old_2017_2018'
		forvalues i = 1/`n_2017_2018' {
			local old_code : word `i' of `old_2017_2018'
			local new_code : word `i' of `new_2017_2018'
			replace new = "`new_code'" if old == "`old_code'"
			replace change_type = 1    if old == "`old_code'"
		}

		*** Municipality mergers

		*	Larvik (0712) was created by merging Larvik (0709) and Lardal
		*	(0728)
		replace new = "0712"    if inlist(old, "0709", "0728")
		replace change_type = 2 if new == "0712"

		*	Holmestrand (0715) was created by merging Holmestrand (0702) and
		*	Hof (0714)
		replace new = "0715"    if inlist(old, "0702", "0714")
		replace change_type = 2 if new == "0715"

		*	Faerder (0729) was created by merging Notteroy (0722) and Tjome
		*	(0723)
		replace new = "0729"    if inlist(old, "0722", "0723")
		replace change_type = 2 if new == "0729"

		*	Indre Fosen (5054) was created by merging Rissa (1624) and Leksvik
		*	(1718)
		replace new = "5054"    if inlist(old, "1624", "1718")
		replace change_type = 2 if new == "5054"
	}
	else if "`vintage'" == "2018_to_2019" {
		* Apply changes as described in
		* https://www.ssb.no/klass/klassifikasjoner/131/versjon/1102/endringer
		*** Pure renumbering: Rindal (1567) transferred from More og Romsdal to
		*	Trondelag county, taking the new code 5061 with no boundary or name
		*	change
		replace new = "5061"    if old == "1567"
		replace change_type = 1 if old == "1567"
	}
	else if "`vintage'" == "2019_to_2020" {
		* Apply changes as described in
		* https://www.ssb.no/klass/klassifikasjoner/131/versjon/1860/endringer

		*** Pure renumbering into the counties formed by the 2020 county
		*	reform (Viken, Innlandet, Vestfold og Telemark, Agder, Vestland,
		*	Troms og Finnmark). Every municipality that was not also merging
		*	with a neighbour (those are in the mergers section below) took a
		*	new county-prefixed code with no boundary or name change.
		*	Verified against SSB Klass classification 131, version 1860.
		#delimit ;
		local old_2019_2020 0101 0105 0106 0111 0118 0119 0127 0128
							0135 0137 0211 0214 0215 0216 0219 0228
							0229 0230 0233 0234 0235 0236 0237 0238
							0239 0532 0533 0604 0605 0612 0615 0616
							0617 0618 0619 0620 0621 0622 0623 0624
							0626 0631 0632 0633 0701 0710 0712 0729
							0805 0806 0807 0811 0814 0815 0817 0819
							0826 0827 0828 0829 0830 0831 0833 0834
							1902 1903 1911 1917 1919 1920 1922 1923
							1924 1925 1926 1933 1936 1938 1939 1940
							1941 1942 1943 2002 2003 2011 2012 2014
							2015 2018 2019 2020 2021 2022 2023 2024
							2025 2027 2028 2030 0402 0403 0501 0502
							0412 0415 0417 0418 0419 0420 0423 0425
							0426 0427 0428 0429 0430 0432 0434 0436
							0437 0438 0439 0441 0511 0512 0513 0514
							0515 0516 0517 0519 0520 0521 0522 0528
							0529 0534 0536 0538 0540 0541 0542 0543
							0544 0545 0901 0904 0906 1003 1004 0911
							0912 0914 0919 0926 0928 0929 0935 0937
							0938 0940 0941 1014 1026 1034 1037 1046
							1201 1211 1216 1219 1221 1222 1223 1224
							1232 1233 1238 1242 1244 1247 1251 1252
							1253 1264 1265 1266 1411 1412 1413 1416
							1417 1421 1422 1424 1426 1428 1429 1438
							1445 1449;
		local new_2019_2020 3001 3003 3004 3011 3012 3013 3015 3016
							3017 3018 3019 3021 3022 3023 3024 3027
							3028 3029 3031 3032 3033 3034 3035 3036
							3037 3053 3054 3006 3007 3038 3039 3040
							3041 3042 3043 3044 3045 3046 3047 3048
							3049 3050 3051 3052 3801 3804 3805 3811
							3806 3807 3808 3812 3813 3814 3815 3816
							3818 3819 3820 3821 3822 3823 3824 3825
							5401 5402 5411 5413 5414 5415 5416 5417
							5418 5419 5420 5422 5423 5424 5425 5426
							5427 5428 5429 5404 5405 5430 5403 5432
							5433 5434 5435 5436 5437 5438 5439 5440
							5441 5442 5443 5444 3401 3403 3405 3407
							3411 3412 3413 3414 3415 3416 3417 3418
							3419 3420 3421 3422 3423 3424 3425 3426
							3427 3428 3429 3430 3431 3432 3433 3434
							3435 3436 3437 3438 3439 3440 3441 3442
							3443 3446 3447 3448 3449 3450 3451 3452
							3453 3454 4201 4202 4203 4206 4207 4211
							4212 4213 4214 4215 4216 4217 4218 4219
							4220 4221 4222 4223 4224 4226 4227 4228
							4601 4611 4612 4613 4614 4615 4616 4617
							4619 4620 4622 4623 4625 4627 4628 4629
							4630 4632 4633 4634 4635 4636 4637 4638
							4639 4641 4642 4643 4644 4645 4646 4648
							4650 4651;
		#delimit cr
		local n_2019_2020 : word count `old_2019_2020'
		forvalues i = 1/`n_2019_2020' {
			local old_code : word `i' of `old_2019_2020'
			local new_code : word `i' of `new_2019_2020'
			replace new = "`new_code'" if old == "`old_code'"
			replace change_type = 1    if old == "`old_code'"
		}
		
		*** Municipality splits
		*	Tysfjord (1850) was split between Narvik (1806) and 
		*	Hábmer - Hamarøy (1875).
		expand 2 if old == "1850"
		*** Snillfjord (5012) was split three ways between Heim, Hitra, and 
		*	Orkland.
		expand 3 if old == "5012"
		
		bysort old: gen idx = _n
		
		*	(1850) -> (1806) and (1875)
		replace new = "1806"    if old == "1850" & idx == 1
		replace new = "1875"	if old == "1850" & idx == 2
		replace change_type = 4 if old == "1850"
		*	(5012) -> (5055), (5056), and (5059)
		replace new = "5055"    if old == "5012" & idx == 1
		replace new = "5056"    if old == "5012" & idx == 2
		replace new = "5059"    if old == "5012" & idx == 3
		replace change_type = 4 if old == "5012"
		
		drop idx
		
		*** Municipality mergers
		
		*	Stavanger (1103) incorporated Finnøy (1141) and Rennesøy (1142)
		replace new = "1103"    if inlist(old, "1103", "1141", "1142")
		replace change_type = 2 if new == "1103"
		*	Sandnes (1108) was created by merging Sandnes (1102) and
		*	Forsand (1129)
		replace new = "1108"    if inlist(old, "1102", "1129")
		replace change_type = 2 if new == "1108"
		*	Molde (1506) was created by merging Molde (1502), Nesset (1543),
		*	and Midsund (1545)
		replace new = "1506"    if inlist(old, "1502", "1543", "1545")
		replace change_type = 2 if new == "1506"
		*	Ålesund (1507) was created by merging Ålesund (1504), Ørskog
		*	(1523), Skodje (1529), Haram (1534), and Sandøy (1546)
		replace new = "1507"    if inlist(old, "1504", "1523", "1529", "1534", ///
																	"1546")
		replace change_type = 2 if new == "1507"
		*	Volda (1577) was created by merging Hornindal (1444) and Volda
		*	(1519)
		replace new = "1577"    if inlist(old, "1444", "1519")
		replace change_type = 2 if new == "1577"
		*	Fjord (1578) was created by merging Norddal (1524) and Stordal
		*	(1526)
		replace new = "1578"    if inlist(old, "1524", "1526")
		replace change_type = 2 if new == "1578"
		*	Hustadvika (1579) was created by merging Fræna (1548) and Eide
		*	(1551)
		replace new = "1579"    if inlist(old, "1548", "1551")
		replace change_type = 2 if new == "1579"

		*	Narvik (1806) was created by merging Narvik (1805), 
		*	Ballangen (1854), and a part of Tysfjord (1850) -- the Tysfjord
		*	branch is treated above
		replace new = "1806" if inlist(old, "1805", "1854")
		replace change_type = 2 if new == "1806" & change_type == .
		*	Hábmer - Hamarøy (1875) merged Hamarøy (1849) and a part of
		*	Tysfjord (1850) -- the Tysfjord branch is treated above
		replace new = "1875" if old == "1849"
		replace change_type = 2 if new == "1875" & change_type == .
		*	Moss (3002) was created by merging Moss (0104) and Rygge (0136)
		replace new = "3002"    if inlist(old, "0104", "0136")
		replace change_type = 2 if new == "3002"
		*	Drammen (3005) was created by merging Drammen (0602), Nedre Eiker
		*	(0625), and Svelvik (0711)
		replace new = "3005"    if inlist(old, "0602", "0625", "0711")
		replace change_type = 2 if new == "3005"
		*	Indre Østfold (3014) was created by merging Trøgstad (0122),
		*	Spydeberg (0123), Askim (0124), Eidsberg (0125), and Hobøl (0138)
		replace new = "3014"    if inlist(old, "0122", "0123", "0124", "0125", ///
																	"0138")
		replace change_type = 2 if new == "3014"
		*	Nordre Follo (3020) was created by merging Ski (0213) and Oppegård
		*	(0217)
		replace new = "3020"    if inlist(old, "0213", "0217")
		replace change_type = 2 if new == "3020"
		*	Asker (3025) was created by merging Asker (0220), Røyken (0627),
		*	and Hurum (0628)
		replace new = "3025"    if inlist(old, "0220", "0627", "0628")
		replace change_type = 2 if new == "3025"
		*	Aurskog-Høland (3026) was created by merging Rømskog (0121) and
		*	Aurskog-Høland (0221)
		replace new = "3026"    if inlist(old, "0121", "0221")
		replace change_type = 2 if new == "3026"
		*	Lillestrøm (3030) was created by merging Sørum (0226), Fet (0227),
		*	and Skedsmo (0231)
		replace new = "3030"    if inlist(old, "0226", "0227", "0231")
		replace change_type = 2 if new == "3030"
		*	Holmestrand (3802) was created by merging Sande (0713) and
		*	Holmestrand (0715)
		replace new = "3802"    if inlist(old, "0713", "0715")
		replace change_type = 2 if new == "3802"
		*	Tønsberg (3803) was created by merging Tønsberg (0704) and Re
		*	(0716)
		replace new = "3803"    if inlist(old, "0704", "0716")
		replace change_type = 2 if new == "3803"
		*	Midt-Telemark (3817) was created by merging Bø (0821) and Sauherad
		*	(0822)
		replace new = "3817"    if inlist(old, "0821", "0822")
		replace change_type = 2 if new == "3817"
		*	Kristiansand (4204) was created by merging Kristiansand (1001),
		*	Songdalen (1017), and Søgne (1018)
		replace new = "4204"    if inlist(old, "1001", "1017", "1018")
		replace change_type = 2 if new == "4204"
		*	Lindesnes (4205) was created by merging Mandal (1002), Marnardal
		*	(1021), and Lindesnes (1029)
		replace new = "4205"    if inlist(old, "1002", "1021", "1029")
		replace change_type = 2 if new == "4205"
		*	Lyngdal (4225) was created by merging Audnedal (1027) and Lyngdal
		*	(1032)
		replace new = "4225"    if inlist(old, "1027", "1032")
		replace change_type = 2 if new == "4225"
		*	Kinn (4602) was created by merging Flora (1401) and Vågsøy (1439)
		replace new = "4602"    if inlist(old, "1401", "1439")
		replace change_type = 2 if new == "4602"
		*	Ullensvang (4618) was created by merging Jondal (1227), Odda
		*	(1228), and Ullensvang (1231)
		replace new = "4618"    if inlist(old, "1227", "1228", "1231")
		replace change_type = 2 if new == "4618"
		*	Voss (4621) was created by merging Granvin (1234) and Voss (1235)
		replace new = "4621"    if inlist(old, "1234", "1235")
		replace change_type = 2 if new == "4621"
		*	Bjørnafjorden (4624) was created by merging Fusa (1241) and Os
		*	(Hordaland) (1243)
		replace new = "4624"    if inlist(old, "1241", "1243")
		replace change_type = 2 if new == "4624"
		*	Øygarden (4626) was created by merging Sund (1245), Fjell (1246),
		*	and Øygarden (1259)
		replace new = "4626"    if inlist(old, "1245", "1246", "1259")
		replace change_type = 2 if new == "4626"
		*	Alver (4631) was created by merging Meland (1256), Radøy (1260),
		*	and Lindås (1263)
		replace new = "4631"    if inlist(old, "1256", "1260", "1263")
		replace change_type = 2 if new == "4631"
		*	Sogndal (4640) was created by merging Balestrand (1418), Leikanger
		*	(1419), and Sogndal (1420)
		replace new = "4640"    if inlist(old, "1418", "1419", "1420")
		replace change_type = 2 if new == "4640"
		*	Sunnfjord (4647) was created by merging Gaular (1430), Jølster
		*	(1431), Førde (1432), and Naustdal (1433)
		replace new = "4647"    if inlist(old, "1430", "1431", "1432", "1433")
		replace change_type = 2 if new == "4647"
		*	Stad (4649) was created by merging Selje (1441) and Eid (1443)
		replace new = "4649"    if inlist(old, "1441", "1443")
		replace change_type = 2 if new == "4649"
		*	Trondheim (5001) incorporated Klæbu (5030)
		replace new = "5001"    if inlist(old, "5001", "5030")
		replace change_type = 2 if new == "5001"
		*	Steinkjer (5006) was created by merging Steinkjer (5004) and
		*	Verran (5039)
		replace new = "5006"    if inlist(old, "5004", "5039")
		replace change_type = 2 if new == "5006"
		*	Namsos (5007) was created by merging Namsos (5005), Namdalseid
		*	(5040), and Fosnes (5048)
		replace new = "5007"    if inlist(old, "5005", "5040", "5048")
		replace change_type = 2 if new == "5007"

		*	Heim (5055) was created by merging Halsa (1571), Hemne (5011), and
		*	a part of Snillfjord (5012), treated above
		replace new = "5055"    if inlist(old, "1571", "5011")
		replace change_type = 2 if new == "5055" & change_type == .
		
		*	Hitra (5056) was created from (5013) after merging with a part
		*	of Snillfjord (5012), treated above
		replace new = "5056"    if old == "5013"
		replace change_type = 2 if new == "5056" & change_type == .
		
		*	Orkland (5059) was created by merging Agdenes (5016), Meldal (5023),
		*	Orkdal (5024), and a part of Snillfjord (5012), treated above
		replace new = "5059"    if inlist(old, "5016", "5023", "5024")
		replace change_type = 2 if new == "5059" & change_type == .

		*	Ørland (5057) was created by merging Ørland (5015) and Bjugn (5017)
		replace new = "5057"    if inlist(old, "5015", "5017")
		replace change_type = 2 if new == "5057"
		*	Åfjord (5058) was created by merging Åfjord (5018) and Roan (5019)
		replace new = "5058"    if inlist(old, "5018", "5019")
		replace change_type = 2 if new == "5058"
		*	Nærøysund (5060) was created by merging Vikna (5050) and Nærøy
		*	(5051)
		replace new = "5060"    if inlist(old, "5050", "5051")
		replace change_type = 2 if new == "5060"
		*	Hammerfest - Hámmerfeasta (5406) was created by merging
		*	Hammerfest - Hámmerfeasta (2004) and Kvalsund (2017)
		replace new = "5406"    if inlist(old, "2004", "2017")
		replace change_type = 2 if new == "5406"
		*	Dielddanuorri - Tjeldsund (5412) was created by merging
		*	Dielddanuorri - Tjeldsund (1852) and Skånland (1913)
		replace new = "5412"    if inlist(old, "1852", "1913")
		replace change_type = 2 if new == "5412"
		*	Senja (5421) was created by merging Tranøy (1927), Torsken (1928),
		*	Berg (1929), and Lenvik (1931)
		replace new = "5421"    if inlist(old, "1927", "1928", "1929", "1931")
		replace change_type = 2 if new == "5421"
	}
	else if "`vintage'" == "2020_to_2024" { // Skip 2022 & 2023, only spelling
		*** https://www.ssb.no/klass/klassifikasjoner/131/versjon/1710/endringer

		*** Municipality split
		*	Ålesund (1507) was split between Ålesund (1508) and Haram (1580).
		expand 2 if old == "1507", gen(idx)
		*	(1507) -> (1508) and (1580)
		replace new = "1508" if old == "1507" & idx == 0
		replace new = "1580" if old == "1507" & idx == 1
		replace change_type = 3 if old == "1507"
		
		drop idx

		*** Pure renumbering: on 2024-01-01 Viken, Vestfold og Telemark, and
		*	Troms og Finnmark were dissolved back into Østfold, Akershus,
		*	Buskerud, Vestfold, Telemark, Troms and Finnmark, and every
		*	municipality that had been renumbered into one of those three
		*	counties in 2020 took a new county-prefixed code with no boundary
		*	or name change. The Ålesund/Haram split above is the only
		*	structural change this vintage. Sourced from regjeringen.no's
		*	"Nye kommune- og fylkesnummer fra 1. januar 2024" table,
		*	cross-checked against SSB Klass classification 131, version 1710.
		#delimit ;
		local old_2020_2024 3001 3002 3003 3004 3011 3017 3018 3015
							3014 3016 3013 3012 3024 3025 3030 3020
							3033 3023 3022 3019 3021 3028 3029 3027
							3026 3034 3032 3031 3054 3053 3036 3035
							3037 3005 3006 3007 3038 3049 3048 3047
							3046 3039 3040 3041 3042 3043 3044 3045
							3050 3051 3052 3801 3802 3803 3804 3805
							3811 3806 3807 3808 3812 3813 3814 3815
							3816 3817 3820 3819 3818 3821 3822 3823
							3824 3825 5401 5402 5411 5412 5413 5414
							5415 5416 5417 5418 5419 5420 5421 5422
							5423 5424 5425 5426 5427 5428 5429 5403
							5406 5444 5405 5437 5430 5432 5433 5434
							5435 5436 5438 5439 5441 5440 5443 5404
							5442;
		local new_2020_2024 3101 3103 3105 3107 3110 3112 3114 3116
							3118 3120 3122 3124 3201 3203 3205 3207
							3209 3212 3214 3216 3218 3220 3222 3224
							3226 3228 3230 3232 3234 3236 3238 3240
							3242 3301 3303 3305 3310 3312 3314 3316
							3318 3320 3322 3324 3326 3328 3330 3332
							3334 3336 3338 3901 3903 3905 3907 3909
							3911 4001 4003 4005 4010 4012 4014 4016
							4018 4020 4022 4024 4026 4028 4030 4032
							4034 4036 5501 5503 5510 5512 5514 5516
							5518 5520 5522 5524 5526 5528 5530 5532
							5534 5536 5538 5540 5542 5544 5546 5601
							5603 5605 5607 5610 5612 5614 5616 5618
							5620 5622 5624 5626 5628 5630 5632 5634
							5636;
		#delimit cr
		local n_2020_2024 : word count `old_2020_2024'
		forvalues i = 1/`n_2020_2024' {
			local old_code : word `i' of `old_2020_2024'
			local new_code : word `i' of `new_2020_2024'
			replace new = "`new_code'" if old == "`old_code'"
			replace change_type = 1    if old == "`old_code'"
		}
	}
	} // end of qui

	*** Classify each old->new mapping. Renumberings (1) are set in the
	*** paired-list forvalues loops above; mergers (2) and splits (3, 4) are
	*** set by hand on the line below their descriptive comment, vintage by
	*** vintage -- data-alone inference cannot tell a split's surviving
	*** branch from a merger, nor a code-preserving merger from "no change".
	*** Only "no change" (0) is filled in here, from new == old.
	replace change_type = 0 if new == old & change_type == .

	label values change_type change_types
	rename change_type change_type_`old_y'_`new_y'
	
	rename (new old) (muni_code_`new_y' muni_code_`old_y')

	duplicates drop
	gunique muni_code_`old_y'
	
	save "crosswalks/muni_code_vintages_`vintage'", replace
	disp ""
}

******************************************************************************
*** Chain the pairwise crosswalks into one wide crosswalk -- used below to
*	merge on the Bhuller (2009) labor-market regions

clear
local files : dir "crosswalks/" files "muni_code_vintages_*.dta"
local files : list sort files

foreach file in `files' {
	
	disp "`file'"
	
	local vintage = substr("`file'",   20, 12)
	local old_y   = substr("`vintage'", 1, 4)
	local new_y   = substr("`vintage'", 9, 4)
	
	local y_to_merge_on = substr("`vintage'", 1, 4)			
	
	if `y_to_merge_on' == 1995 {
		use "crosswalks/muni_code_vintages_`vintage'"
	}
	else {
		joinby muni_code_`y_to_merge_on' using ///
								"crosswalks/muni_code_vintages_`vintage'"
	}
}

merge m:1 muni_code_2008 using "muni_to_Bhuller_LMAs"
drop _merge

*** Because of the redrawing, merging, and splitting of municipalities,
*	some border municipalities cause non-unique LMAs for later created munis.
*	This is manually handled here.
foreach muni_code of varlist muni_code_* {
	local year = subinstr("`muni_code'", "muni_code_", "", .)
	
	gen arbmarkregion_`year' = arbmarkregion
	
	if `year' > 2011 {
		*** (1723) in LMA 61 and (1729) in LMA 62, -> new (1756) in 2012.
		*	Assigned to LMA 62, since (1723)'s pop. of 874 << (1729)'s pop.
		*	of 5920 in 2007.
		replace arbmark*_`year' = 62 if muni_code_2012 == "1756"
	}
	if `year' > 2019 {
		*** (1444) in LMA 53 and (1519) in LMA 54 -> new (1577) in 2020.
		*	Assigned to LMA 54, since (1444)'s pop >> (1519)'s pop. in 2007
		replace arbmark*_`year' = 54 if muni_code_2020 == "1577"
		*** (1849) in LMA 71 and part of (1850) in LMA 72 -> (1875) in 2020.
		*	Assigned to LMA 71, since only a part of (1850) is being merged.
		replace arbmark*_`year' = 71 if muni_code_2020 == "1875"
		*** (0713) in LMA 12 and (0715) in LMA 13 -> new (3802) in 2020.
		*	Assigned to LMA 12, since (0713)'s pop. of 7827 >> (0715)'s pop.
		*	of 3099 in 2007
		replace arbmark*_`year' = 12 if muni_code_2020 == "3802"
		*** (1032) in LMA 36 and (1027) in LMA 35 -> new (4225) in 2020.
		*	Assigned to LMA 36, since (1032)'s pop. of 7368 >> (1027)'s pop.
		*	of 1595 in 2007
		replace arbmark*_`year' = 36 if muni_code_2020 == "4225"
		*** (1401) in LMA 51 and (1439) in LMA 53 -> new (4602) in 2020.
		*	Assigned to LMA 51, since (1401)'s pop. of 11341 >> (1439)'s pop.
		*	of 6064 in 2007
		replace arbmark*_`year' = 51 if muni_code_2020 == "4602"
		*** (1852) in LMA 72 and (1913) in LMA 75 -> new (5412) in 2020.
		*	Assigned to LMA 75, since (1852)'s pop. of 1352 < (1913)'s pop.
		*	of 2883 in 2007
		replace arbmark*_`year' = 75 if muni_code_2020 == "5412"
		*** (1418) in LMA 51, (1419) and (1420) in LMA 52 -> new (4640) in 2020.
		*	Assigned to LMA 52, since (1418)'s pop. of 1399 << the sum of
		*	(1419) and (1420)'s pop.s of 2199 and 6822, respectively.
		replace arbmark*_`year' = 52 if muni_code_2020 == "4640"
		*** (1725) in LMA 62, (1703) and (1748) in LMA 63 -> new (5007) in 2020.
		*	Assigned to LMA 63 since (1725)'s pop. of 1741 << the sum of 
		*	(1703) and (1748) pop.s of 12573 and 712, respectively.
		replace arbmark*_`year' = 63 if muni_code_2020 == "5007"
		*** (1571) in LMA 57, (5011) and (5012) in LMA 61 -> new (5055) in 2020.
		*	Assigned to LMA 61 since (1571)'s pop. of 1671 < the sum of
		*	(1612) and (1613) pop.s of 4247 and part of 1021, respectively.
		replace arbmark*_`year' = 61 if muni_code_2020 == "5055"
	}
}

drop arbmarkregion

*** Check that no other municipality moves between LMAs due to mergers and 
*	splits
foreach muni_code of varlist muni_code_* {
	local year = subinstr("`muni_code'", "muni_code_", "", .)
	qui {	
		egen tag = tag(`muni_code' arbmarkregion_`year')
		bysort `muni_code': egen N_combos = total(tag)
		sum N_combos
		if `r(max)' > 1 {
			br if N_combos > 1
			disp as error "Muni-LMA is not unique across time using `muni_code'"
			pause
		}
		drop tag N_combos
	}
}

save "crosswalks/muni_code_multiple_vintages", replace

******************************************************************************
*** Split it up into pairwise crosswalks again but with LMAs merged on

use "crosswalks/muni_code_multiple_vintages", clear

local files : dir "crosswalks/" files "muni_code_vintages_*.dta"
local files : list sort files
foreach file in `files' {
	
	local vintage = substr("`file'",   20, 12)
	local old_y   = substr("`vintage'", 1, 4)
	local new_y   = substr("`vintage'", 9, 4)
	
	preserve
	keep muni*_`old_y' muni*_`new_y' arbmarkregion_`new_y' *_`old_y'_`new_y'
	
	duplicates drop
	gunique muni_code_`old_y'
	if `r(unique)' < _N {
		disp as error "muni_code is not unique in `vintage'"
		bysort muni_code_`old_y': gen N = _N
		br if N > 1
		pause
		drop N
	}
	
	save "crosswalks/`file'", replace
	restore
}

clear

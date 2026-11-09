
/*
	A1: Assign each 2008 municipality to its Bhuller (2009) labor market
	region (arbeidsmarkedsregion).

	Source:
	Bhuller, M. S. (2009). Inndeling av Norge i arbeidsmarkedsregioner.
	Notater 2009/24, Statistisk sentralbyrå (Statistics Norway).
	https://www.ssb.no/arbeid-og-lonn/artikler-og-publikasjoner/inndeling-av-norge-i-arbeidsmarkedsregioner

	Bhuller defines the 46 regions on Kommuneinndeling 2008. The input
	block below lists all 430 municipality codes in that classification,
	and each is assigned a region further down.

	Output: muni_to_Bhuller_LMAs.dta, one row per 2008 municipality code.
	Run before A2 (A0_main.do runs both in order).
*/
clear
#delimit ;
input str4 muni_code_2008;
"0301"; "0213"; "0211"; "0214"; "0215"; "0216"; "0217"; "0219"; "0220"; "0231";
"0221"; "0226"; "0227"; "0228"; "0229"; "0230"; "0233"; "0234"; "0236"; "0235";
"0237"; "0238"; "0239"; "0104"; "0135"; "0136"; "0137"; "0124"; "0125"; "0119";
"0121"; "0122"; "0123"; "0127"; "0138"; "0534"; "0532"; "0533"; "0602"; "0621";
"0623"; "0624"; "0625"; "0626"; "0627"; "0628"; "0605"; "0612"; "0622"; "0713";
"0711"; "0101"; "0118"; "0106"; "0105"; "0111"; "0128"; "0704"; "0701"; "0716";
"0719"; "0720"; "0722"; "0723"; "0702"; "0714"; "0706"; "0709"; "0728"; "0604";
"0631"; "0632"; "0633"; "0617"; "0615"; "0616"; "0618"; "0619"; "0620"; "0542";
"0540"; "0541"; "0543"; "0544"; "0545"; "0516"; "0519"; "0520"; "0517"; "0511";
"0512"; "0513"; "0514"; "0515"; "0501"; "0521"; "0522"; "0502"; "0528"; "0529";
"0536"; "0538"; "0403"; "0412"; "0415"; "0417"; "0402"; "0418"; "0419"; "0420";
"0423"; "0425"; "0427"; "0426"; "0428"; "0429"; "0430"; "0434"; "0437"; "0432";
"0436"; "0438"; "0439"; "0441"; "1640"; "1644"; "0828"; "0829"; "0830"; "0831";
"0833"; "0834"; "0826"; "0807"; "0821"; "0822"; "0827"; "0806"; "0805"; "0811";
"0814"; "0819"; "0815"; "0817"; "0906"; "0904"; "0912"; "0914"; "0919"; "0929";
"0901"; "0911"; "1001"; "1014"; "1017"; "1018"; "1002"; "1021"; "1026"; "1027";
"1029"; "0926"; "0928"; "0937"; "0935"; "0938"; "0940"; "0941"; "1003"; "1032";
"1034"; "1004"; "1037"; "1046"; "1103"; "1102"; "1122"; "1124"; "1127"; "1129";
"1130"; "1133"; "1141"; "1142"; "1144"; "1121"; "1119"; "1120"; "1101"; "1111";
"1112"; "1114"; "1106"; "1134"; "1135"; "1145"; "1146"; "1149"; "1151"; "1211";
"1216"; "1160"; "1221"; "1219"; "1222"; "1223"; "1224"; "1432"; "1413"; "1428";
"1429"; "1430"; "1431"; "1433"; "1401"; "1438"; "1416"; "1418"; "1412"; "1420";
"1424"; "1417"; "1419"; "1421"; "1422"; "1426"; "1439"; "1443"; "1445"; "1449";
"1441"; "1444"; "1516"; "1511"; "1514"; "1515"; "1517"; "1520"; "1519"; "1504";
"1523"; "1524"; "1525"; "1526"; "1528"; "1529"; "1531"; "1532"; "1534"; "1546";
"1502"; "1535"; "1539"; "1543"; "1545"; "1547"; "1548"; "1551"; "1557"; "1563";
"1560"; "1566"; "1567"; "1571"; "1505"; "1554"; "1576"; "1573"; "1201"; "1238";
"1241"; "1242"; "1243"; "1244"; "1245"; "1246"; "1247"; "1251"; "1252"; "1253";
"1256"; "1259"; "1260"; "1263"; "1264"; "1265"; "1266"; "1228"; "1227"; "1231";
"1232"; "1235"; "1233"; "1234"; "1411"; "1601"; "1624"; "1648"; "1653"; "1657";
"1662"; "1663"; "1664"; "1665"; "1620"; "1617"; "1621"; "1627"; "1630"; "1632";
"1633"; "1634"; "1635"; "1638"; "1612"; "1613"; "1622"; "1636"; "1714"; "1711";
"1718"; "1723"; "1702"; "1724"; "1725"; "1729"; "1736"; "1719"; "1721"; "1717";
"1703"; "1743"; "1744"; "1748"; "1749"; "1742"; "1738"; "1739"; "1740"; "1750";
"1751"; "1755"; "1820"; "1818"; "1822"; "1827"; "1834"; "1835"; "1813"; "1811";
"1812"; "1815"; "1816"; "1824"; "1825"; "1826"; "1833"; "1828"; "1832"; "1804";
"1836"; "1837"; "1838"; "1839"; "1840"; "1841"; "1845"; "1848"; "1849"; "1805";
"1850"; "1851"; "1852"; "1853"; "1854"; "1919"; "1870"; "1866"; "1867"; "1868";
"1871"; "1865"; "1856"; "1857"; "1859"; "1860"; "1874"; "1901"; "1911"; "1913";
"1915"; "1917"; "1924"; "1920"; "1922"; "1923"; "1931"; "1925"; "1926"; "1927";
"1928"; "1929"; "1902"; "1933"; "1936"; "1938"; "1939"; "1942"; "1941"; "1943";
"1940"; "2012"; "2011"; "2014"; "2015"; "2004"; "2017"; "2018"; "2019"; "2020";
"2021"; "2022"; "2023"; "2003"; "2002"; "2024"; "2025"; "2027"; "2028"; "2030";
end;
#delimit cr

*** Start by defining the variable
generate arbmarkregion = .

*	Define Oslo
*	(first number in Bhuller is a typo, specifically for Oslo, 0391 -> 0301)
replace arbmark = 12 if inlist(muni, "0301", "0213", "0211", "0214", ///
									 "0215", "0216", "0217", "0219")
replace arbmark = 12 if inlist(muni, "0220", "0231", "0221", "0226", ///
									 "0227", "0228", "0229", "0230")
replace arbmark = 12 if inlist(muni, "0233", "0234", "0236", "0235", ///
									 "0237", "0238", "0239", "0104")
replace arbmark = 12 if inlist(muni, "0135", "0136", "0137", "0124", ///
									 "0125", "0119", "0121", "0122")
replace arbmark = 12 if inlist(muni, "0123", "0127", "0138", "0534", ///
									 "0532", "0533", "0602", "0621")
replace arbmark = 12 if inlist(muni, "0623", "0624", "0625", "0626", ///
									 "0627", "0628", "0605", "0612")
replace arbmark = 12 if inlist(muni, "0622", "0713", "0711")

*	Define Sør-Østfold
replace arbmark = 11 if inlist(muni, "0101", "0118", "0106", "0105", ///
													 "0111", "0128")

*	Define Vestfold
replace arbmark = 13 if inlist(muni, "0704", "0701", "0716", "0719", ///
									 "0720", "0722", "0723", "0702")
replace arbmark = 13 if inlist(muni, "0714", "0706", "0709", "0728")

*	Define Kongsberg
replace arbmark = 14 if inlist(muni, "0604", "0631", "0632", "0633")

*	Define Hallingdal
replace arbmark = 15 if inlist(muni, "0617", "0615", "0616", "0618", ///
													 "0619", "0620")
											
*	Define Valdres
replace arbmark = 21 if inlist(muni, "0542", "0540", "0541", "0543", ///
											 "0544", "0545")

*	Define Gudbrandsdalen
replace arbmark = 22 if inlist(muni, "0516", "0519", "0520", "0517", ///
									 "0511", "0512", "0513", "0514", ///
															 "0515")
											
*	Define Lillehammer
replace arbmark = 23 if inlist(muni, "0501", "0521", "0522")

*	Define Gjøvik
replace arbmark = 24 if inlist(muni, "0502", "0528", "0529", "0536", ///
															 "0538")
											
*	Define Hamar
replace arbmark = 25 if inlist(muni, "0403", "0412", "0415", "0417")

*	Define Kongsvinger
replace arbmark = 26 if inlist(muni, "0402", "0418", "0419", "0420", ///
													 "0423", "0425")

*	Define Elverum
replace arbmark = 27 if inlist(muni, "0427", "0426", "0428", "0429", ///
													 "0430", "0434")

*	Define Tynset/Røros
replace arbmark = 28 if inlist(muni, "0437", "0432", "0436", "0438", ///
									 "0439", "0441", "1640", "1644")

*	Define Nordvest-Telemark
replace arbmark = 31 if inlist(muni, "0828", "0829", "0830", "0831", ///
									 "0833", "0834", "0826")

*	Define Øst-Telemark
replace arbmark = 32 if inlist(muni, "0807", "0821", "0822", "0827")

*	Define Sør-Telemark
replace arbmark = 33 if inlist(muni, "0806", "0805", "0811", "0814", ///
											 "0819", "0815", "0817")

*	Define Arendal
replace arbmark = 34 if inlist(muni, "0906", "0904", "0912", "0914", ///
											 "0919", "0929", "0901", "0911")

*	Define Kristiansand
replace arbmark = 35 if inlist(muni, "1001", "1014", "1017", "1018", ///
											 "1002", "1021", "1026", "1027")
replace arbmark = 35 if inlist(muni, "1029", "0926", "0928", "0937", ///
											 "0935", "0938", "0940", "0941")

*	Define Lister
replace arbmark = 36 if inlist(muni, "1003", "1032", "1034", "1004", ///
											 "1037", "1046")

*	Define Stavanger
replace arbmark = 41 if inlist(muni, "1103", "1102", "1122", "1124", ///
									 "1127", "1129", "1130", "1133")
replace arbmark = 41 if inlist(muni, "1141", "1142", "1144", "1121", ///
									 "1119", "1120", "1101", "1111")
replace arbmark = 41 if inlist(muni, "1112", "1114")

*	Define Haugesund
replace arbmark = 42 if inlist(muni, "1106", "1134", "1135", "1145", ///
									 "1146", "1149", "1151", "1211")
replace arbmark = 42 if inlist(muni, "1216", "1160")

*	Define Sunnhordland
replace arbmark = 43 if inlist(muni, "1221", "1219", "1222", "1223", ///
															 "1224")

*	Define Sunnfjord
replace arbmark = 51 if inlist(muni, "1432", "1413", "1428", "1429", ///
									 "1430", "1431", "1433", "1401")
replace arbmark = 51 if inlist(muni, "1438", "1416", "1418", "1412")

*	Define Sognefjord
replace arbmark = 52 if inlist(muni, "1420", "1424", "1417", "1419", ///
											 "1421", "1422", "1426")

*	Define Nordfjord
replace arbmark = 53 if inlist(muni, "1439", "1443", "1445", "1449", ///
													 "1441", "1444")

*	Define Søndre Sunnmøre
replace arbmark = 54 if inlist(muni, "1516", "1511", "1514", "1515", ///
											"1517", "1520", "1519")
											
*	Define Ålesund
replace arbmark = 55 if inlist(muni, "1504", "1523", "1524", "1525", ///
									 "1526", "1528", "1529", "1531")
replace arbmark = 55 if inlist(muni, "1532", "1534", "1546")


*	Define Molde
replace arbmark = 56 if inlist(muni, "1502", "1535", "1539", "1543", ///
									 "1545", "1547", "1548", "1551")
replace arbmark = 56 if inlist(muni, "1557")

*	Define Nordmøre
replace arbmark = 57 if inlist(muni, "1563", "1560", "1566", "1567", ///
											"1571")

*	Define Kristiansund
replace arbmark = 58 if inlist(muni, "1505", "1554", "1576", "1573")

*	Define Bergen
replace arbmark = 44 if inlist(muni, "1201", "1238", "1241", "1242", ///
									 "1243", "1244", "1245", "1246")
replace arbmark = 44 if inlist(muni, "1247", "1251", "1252", "1253", ///
									 "1256", "1259", "1260", "1263")
replace arbmark = 44 if inlist(muni, "1264", "1265", "1266", "1228", ///
									 "1227", "1231", "1232", "1235")
replace arbmark = 44 if inlist(muni, "1233", "1234", "1411")											

*	Define Trondheim
replace arbmark = 61 if inlist(muni, "1601", "1624", "1648", "1653", ///
									 "1657", "1662", "1663", "1664")
replace arbmark = 61 if inlist(muni, "1665", "1620", "1617", "1621", ///
									 "1627", "1630", "1632", "1633")
replace arbmark = 61 if inlist(muni, "1634", "1635", "1638", "1612", ///
									 "1613", "1622", "1636", "1714")
replace arbmark = 61 if inlist(muni, "1711", "1718", "1723")

*	Define Midt-Trøndelag
replace arbmark = 62 if inlist(muni, "1702", "1724", "1725", "1729", ///
									 "1736", "1719", "1721", "1717")

*	Define Namsos
replace arbmark = 63 if inlist(muni, "1703", "1743", "1744", "1748", ///
									 "1749", "1742", "1738", "1739")
replace arbmark = 63 if inlist(muni, "1740", "1750", "1751", "1755")

*	Define Ytre Helgeland
replace arbmark = 64 if inlist(muni, "1820", "1818", "1822", "1827", ///
											"1834", "1835", "1813", "1811")
replace arbmark = 64 if inlist(muni, "1812", "1815", "1816")

*	Define Indre Helgeland
replace arbmark = 65 if inlist(muni, "1824", "1825", "1826", "1833", ///
											"1828", "1832")

*	Define Bodø
replace arbmark = 71 if inlist(muni, "1804", "1836", "1837", "1838", ///
											"1839", "1840", "1841", "1845")
replace arbmark = 71 if inlist(muni, "1848", "1849")

*	Define Narvik
replace arbmark = 72 if inlist(muni, "1805", "1850", "1851", "1852", ///
											"1853", "1854", "1919")

*	Define Vesterålen
replace arbmark = 73 if inlist(muni, "1870", "1866", "1867", "1868", ///
											"1871")

*	Define Lofoten
replace arbmark = 74 if inlist(muni, "1865", "1856", "1857", "1859", ///
											"1860", "1874")

*	Define Harstad
replace arbmark = 75 if inlist(muni, "1901", "1911", "1913", "1915", ///
											"1917")

*	Define Midt-Troms
replace arbmark = 76 if inlist(muni, "1924", "1920", "1922", "1923", ///
											"1931", "1925", "1926", "1927")
replace arbmark = 76 if inlist(muni, "1928", "1929")

*	Define Tromsø
replace arbmark = 77 if inlist(muni, "1902", "1933", "1936", "1938", ///
											"1939", "1942", "1941", "1943")
replace arbmark = 77 if inlist(muni, "1940")

*	Define Alta
replace arbmark = 81 if inlist(muni, "2012", "2011", "2014", "2015")

*	Define Hammerfest
replace arbmark = 82 if inlist(muni, "2004", "2017", "2018", "2019", ///
											"2020", "2021", "2022", "2023")

*	Define Vadsø
replace arbmark = 83 if inlist(muni, "2003", "2002", "2024", "2025", ///
											"2027", "2028", "2030")

*** Compare to PDF
*	The contrived loop below is to list the municipalities in the same order
*	as they are defined which is the same order as in the PDF by Bhuller (2009)
preserve
qui {
	gunique arbmark
	
	forval iter = 1/`r(unique)' {
		local kode = arbmark[1]
		noi disp "Arbeidsmarkedsregion `kode'"
		noi list muni if arbmark == `kode'
		
		drop if arbmark == `kode'
	}
}
restore

save "muni_to_Bhuller_LMAs", replace

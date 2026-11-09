/*
	A0_main.do -- builds every output in this repository from scratch.

	Run from the repository root:

		do A0_main.do

	Order matters: A1 creates muni_to_Bhuller_LMAs.dta, which A2 merges
	onto the municipality-code crosswalks. A2 also exports all outputs
	to csv/. No user-written packages are required.
*/

clear all

do "A1_define_labor_market_regions.do"
do "A2_create_muni_code_vintages_crosswalks.do"

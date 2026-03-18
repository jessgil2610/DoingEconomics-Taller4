*=====================================================================
* Doing Economics - Taller #4: Experimentos
* Realizado por: Jessica Gil
*=====================================================================

clear all
ssc install schemepack, replace
set dp comma
set seed 12345
global ruta "C:\Users\jessi\OneDrive\Documents\GitHub\DoingEconomics-Taller4"


**# 2.1. Recolectando datos
{
* Cargar base de datos
import excel "$ruta\RawData\haciendo eocnomia 2026.xlsx", sheet("Hoja1") firstrow

**## 2.1.1. Gráfico de lineas con la distribución promedio
{
preserve 
collapse (mean) Playerscontributions, by(Round)

twoway (line Playerscontributions Round, lcolor("230 18 11") lwidth(thick)), ///
    ytitle("Contribución Promedio", size(medsmall) color(gs6) margin(r=3)) ///
    ylabel(#5, angle(horizontal) labsize(medsmall) labcolor(gs4) ///
        glcolor(gs12) glwidth(vthin) tlcolor(gs12)) ///
    xtitle("Periodo", size(medsmall) color(gs6) margin(t=3)) ///
    xlabel(#11, labsize(medsmall) labcolor(gs4) tlcolor(gs12)) ///
    title("Contribución promedio a lo largo del juego", ///
        size(medium) color(gs2) just(left) margin(b=1)) ///
    subtitle("Gráfico 1", size(small) color(gs6) just(left) margin(b=4)) ///
    note("Fuente: Elaboración propia.", size(vsmall) color(gs8)) ///
    yline(0, lcolor(gs4) lwidth(thin)) ///
    graphregion(color(white) margin(l=5 r=5 t=5 b=5)) ///
    plotregion(color(white) lcolor(none)) ///
    scheme(s1color)
	
graph export "$ruta\Results\Gráfico1_Contribucion_promedio.png",  as(png) replace
restore
}
}

**# 2.2. Describiendo datos
{
* Hay dos tablas en el excel por lo que se importarán por separado
import excel "$ruta\RawData\doing-economics-datafile-working-in-excel-project-2.xlsx", sheet("Public goods contributions") cellrange(A2:Q12)  firstrow clear
gen experimento=1
save "$ruta\RawData\experimento1_Herrmann.dta", replace

import excel "$ruta\RawData\doing-economics-datafile-working-in-excel-project-2.xlsx", sheet("Public goods contributions") cellrange(A16:Q26) firstrow clear
gen experimento=2
save "$ruta\RawData\experimento2_Herrmann.dta", replace

append using "$ruta\RawData\experimento1_Herrmann.dta"
save "$ruta\RawData\experimentos_Herrmann.dta", replace

* Calcular contribución promedio por fila(rondas) para ambos experimentos
egen mean_contributions=rowmean(Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne)

* Gráfico de lineas con la contribución promedio, con una línea separada por cada experimento
**## 2.2.1. Gráfico de líneas por experimento
{
twoway ///
    (line mean_contributions Period if experimento == 1, ///
        lcolor("230 18 11") lwidth(thick)) ///
    (line mean_contributions Period if experimento == 2, ///
        lcolor("0 107 162") lwidth(thick) lpattern(shortdash)), ///
    ytitle("Contribución promedio", size(medsmall) color(gs6) margin(r=3)) ///
    xtitle("Periodo", size(medsmall) color(gs6) margin(t=3)) ///
    xlabel(1(1)10, labsize(medsmall) labcolor(gs4) tlcolor(gs12)) ///
    ylabel(0(2)20, angle(horizontal) labsize(medsmall) labcolor(gs4) ///
        glcolor(gs12) glwidth(vthin) tlcolor(gs12)) ///
    title("Contribución promedio por experimento", ///
        size(medium) color(gs2) just(left) margin(b=1)) ///
    subtitle("Gráfico 2", size(small) color(gs6) just(left) margin(b=4)) ///
    note("Fuente: Herrmann, Thöni y Gächter (2008). Elaboración propia.", ///
        size(vsmall) color(gs8)) ///
    legend(on order(1 "Sin castigo (Exp. 1)" 2 "Con castigo (Exp. 2)") ///
        size(small) region(lcolor(none)) pos(6) rows(1) bmargin(t=2)) ///
    yline(0, lcolor(gs4) lwidth(thin)) ///
    graphregion(color(white) margin(l=5 r=5 t=5 b=5)) ///
    plotregion(color(white) lcolor(none)) ///
    scheme(s1color)

graph export "$ruta\Results\Gráfico2_Contribucion_promedio_exp.png", as(png) replace
}

**## 2.2.2 Gráfico de columnas del la contribución promedio en el primer y último periodo para ambos experimentos 
{
preserve // Para no perder la base de datos completa
keep if Period == 1 | Period == 10
keep Period experimento mean_contributions

reshape wide mean_contributions, i(Period) j(experimento)

graph bar mean_contributions1 mean_contributions2, ///
    over(Period, relabel(1 "Período 1" 2 "Período 10") ///
        label(labsize(small))) ///
    bar(1, color("230 18 11") fintensity(80)) ///
    bar(2, color("0 107 162") fintensity(80)) ///
    ytitle("Contribución promedio", size(medsmall) color(gs6) margin(r=3)) ///
    ylabel(0(2)20, angle(horizontal) labsize(medsmall) labcolor(gs4) ///
        glcolor(gs12) glwidth(vthin) tlcolor(gs12)) ///
    title("Contribución promedio en Período 1 y 10", ///
        size(medium) color(gs2) just(left) margin(b=1)) ///
    subtitle("Gráfico 3", size(small) color(gs6) just(left) margin(b=4)) ///
    note("Fuente: Herrmann, Thöni y Gächter (2008). Elaboración propia.", ///
        size(vsmall) color(gs8)) ///
    legend(on order(1 "Sin castigo (Exp. 1)" 2 "Con castigo (Exp. 2)") ///
        size(small) region(lcolor(none)) pos(6) rows(1) bmargin(t=2)) ///
    graphregion(color(white) margin(l=5 r=5 t=5 b=5)) ///
    plotregion(color(white) lcolor(none)) ///
    scheme(s1color)

graph export "$ruta\Results\Gráfico3_Barras.png", as(png) replace
restore
}

**## 2.2.3 Calcular desviación estandar para los periodos 1 y 10 por separado
{
* Estadísticas para Período 1 y 10 por experimento
egen sd_contributions= rowsd(Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne)

list Period experimento mean_contributions sd_contributions if Period == 1 | Period == 10

* Crear tabla con estilo y exportar a Excel, luego copiar al Word
putexcel set "$ruta\Results\Tabla_descriptiva_sd.xlsx", replace

putexcel A1 = "Período" B1 = "Experimento" C1 = "Media" D1 = "Desv. Estándar"
putexcel A2 = "1"  B2 = "Con castigo"    C2 = 10.64 D2 = 3.21
putexcel A3 = "10" B3 = "Con castigo"    C3 = 12.87 D3 = 3.90
putexcel A4 = "1"  B4 = "Sin castigo"    C4 = 10.58 D4 = 2.02
putexcel A5 = "10" B5 = "Sin castigo"    C5 = 4.38  D5 = 2.19
}

**## 2.2.4 Calcular el valor máximo y minimo para los periodos 1 y 10 por separado
{
egen max_contributions= rowmax(Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne)

egen min_contributions= rowmin(Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne)

gen variance_contributions = sd_contributions^2
gen range_contributions = max_contributions - min_contributions

list Period experimento mean_contributions variance_contributions ///
    sd_contributions min_contributions max_contributions ///
    range_contributions if Period == 1 | Period == 10
	
putexcel set "$ruta\Results\Tabla_descriptiva_completa.xlsx", replace

* Encabezados principales
putexcel B1 = "Sin castigo" C1 = "" D1 = "Con castigo" E1 = ""
putexcel B2 = "Período 1" C2 = "Período 10" D2 = "Período 1" E2 = "Período 10"
putexcel A3 = "Media"
putexcel A4 = "Varianza"
putexcel A5 = "Desv. Estándar"
putexcel A6 = "Mínimo"
putexcel A7 = "Máximo"
putexcel A8 = "Rango"

* Valores Sin castigo
putexcel B3 = 10.58 C3 = 4.38
putexcel B4 = 4.08  C4 = 4.78
putexcel B5 = 2.02  C5 = 2.19
putexcel B6 = 7.96  C6 = 1.30
putexcel B7 = 14.10 C7 = 8.68
putexcel B8 = 6.14  C8 = 7.38

* Valores Con castigo
putexcel D3 = 10.64 E3 = 12.87
putexcel D4 = 10.29 E4 = 15.19
putexcel D5 = 3.21  E5 = 3.90
putexcel D6 = 5.82  E6 = 6.20
putexcel D7 = 16.02 E7 = 17.51
putexcel D8 = 10.20 E8 = 11.31

* Formato: negrita a encabezados
putexcel A1:E2, bold border(all) fpattern(solid, "189 215 238")
putexcel A3:A8, bold border(all) fpattern(solid, "189 215 238")
putexcel B3:E8, border(all) nformat(number_d2)

putexcel B1:C1, merge hcenter bold
putexcel D1:E1, merge hcenter bold
}
}

**# 2.3. ¿Cómo afectó el cambio de reglas del juego al comportamiento?
{
**## 2.3.2. T-test Período 1
{
use "$ruta\RawData\experimentos_Herrmann.dta", clear

* Mantener solo Period 1 y transponer manualmente con xpose
preserve
keep if Period == 1
drop Period

* Transponer: las ciudades pasan a ser filas
xpose, clear varname

* La variable _varname tiene el nombre de la ciudad
* v1 = experimento 2 (con castigo), v2 = experimento 1 (sin castigo)
rename v1 con_castigo
rename v2 sin_castigo

* Eliminar la fila de experimento que no es ciudad
drop if _varname == "experimento"

* T-test
ttest con_castigo == sin_castigo
restore
}

**## 2.3.3. T-test Período 10
{
* Mantener solo Period 10 y transponer manualmente con xpose
preserve
keep if Period == 10
drop Period

* Transponer: las ciudades pasan a ser filas
xpose, clear varname

* La variable _varname tiene el nombre de la ciudad
* v1 = experimento 2 (con castigo), v2 = experimento 1 (sin castigo)
rename v1 con_castigo
rename v2 sin_castigo

* Eliminar la fila de experimento que no es ciudad
drop if _varname == "experimento"

* T-test
ttest con_castigo == sin_castigo
restore
}

}




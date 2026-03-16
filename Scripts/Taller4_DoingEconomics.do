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

* Cargar base de datos
import excel "$ruta\RawData\haciendo eocnomia 2026.xlsx", sheet("Hoja1") firstrow

**## 2.1.1. Gráfico de lineas con la distribución promedio
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

**## 2.2. Describiendo datos

* Hay dos tablas en el excel por lo que se importarán por separado
import excel "$ruta\RawData\doing-economics-datafile-working-in-excel-project-2.xlsx", sheet("Public goods contributions") cellrange(A2:Q12)  firstrow clear
gen experimento=1
save "$ruta\RawData\experimento1_Herrmann.dta", replace

import excel "C:\Users\jessi\OneDrive\Documents\GitHub\DoingEconomics-Taller4\RawData\doing-economics-datafile-working-in-excel-project-2.xlsx", sheet("Public goods contributions") cellrange(A16:Q26) firstrow clear
gen experimento=2
save "$ruta\RawData\experimento2_Herrmann.dta", replace

append using "$ruta\RawData\experimento1_Herrmann.dta"
save "$ruta\RawData\experimentos_Herrmann.dta", replace

* Calcular contribución promedio por fila(rondas) para ambos experimentos
egen mean_contributions=rowmean(Copenhagen Dnipropetrovsk Minsk StGallen Muscat Samara Zurich Boston Bonn Chengdu Seoul Riyadh Nottingham Athens Istanbul Melbourne)

* Gráfico de lineas con la contribución promedio, con una línea separada por cada experimento
twoway ///
    (line mean_contributions Period if experimento==1, ///
        lcolor("230 18 11") lwidth(thick)) ///
    (line mean_contributions Period if experimento==2, ///
        lcolor("0 107 162") lwidth(thick) lpattern(shortdash)), ///
    ytitle("Contribución promedio", size(medsmall) color(gs6) margin(r=3)) ///
    xtitle("Periodo", size(medsmall) color(gs6) margin(t=3)) ///
    xlabel(#10, labsize(medsmall) labcolor(gs4) tlcolor(gs12)) ///
    ylabel(, angle(horizontal) labsize(medsmall) labcolor(gs4) ///
        glcolor(gs12) glwidth(vthin) tlcolor(gs12)) ///
    title("Contribución promedio por experimento", ///
        size(medium) color(gs2) just(left) margin(b=1)) ///
    subtitle("Gráfico 2", size(small) color(gs6) just(left) margin(b=4)) ///
    note("Fuente: Elaboración propia.", size(vsmall) color(gs8)) ///
    legend(on order(1 "Experimento 1" 2 "Experimento 2") ///
        size(small) region(lcolor(none)) pos(6) rows(1) bmargin(t=2)) ///
    yline(0, lcolor(gs4) lwidth(thin)) ///
    graphregion(color(white) margin(l=5 r=5 t=5 b=5)) ///
    plotregion(color(white) lcolor(none)) ///
    scheme(s1color)
	graph export "$ruta\Results\Gráfico2_Contribucion_promedio_exp.png",  as(png) replace







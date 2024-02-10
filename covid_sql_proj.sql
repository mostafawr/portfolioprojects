select location,date,total_cases,new_cases,total_deaths,population
from covid_deaths
order by 1,2


--total cases vs total deaths
-- shows the percentage of dying in your country
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 death_percentage
from covid_deaths
where location like '%Egypt' and continent is not null
order by 1,2

--total cases vs population
--showing what percentage got covid
select location,date,total_cases,population,(total_cases/population)*100 peoplesick_percentage

from covid_deaths
where location like '%Egypt' and continent is not null
order by 1,2

--countries with highest infect rate

select location,max(total_cases) peak_infection_count,population,max((total_cases/population))*100 max_peoplesick_percentage
from covid_deaths
where continent is not null
group by location,population
order by 4 desc


--countries with highest total casualties
select location,max(total_deaths) peak_death_count
from covid_deaths
where continent is not null
group by location
order by 2 desc



--LET'S BREAK THINGS DOWN BY CONTINENT 
--HIGHEST DEATH COUNT PER CONTINENT
select max(total_deaths) peak_death_count,continent
from covid_deaths
where continent is NOT  null
group by continent
order by 1 DESC




--Global numbers 

	select sum(CAST(new_cases AS INT) ) total_cases,sum(cast(new_deaths as int)) total_deaths,sum(cast(new_deaths as float))/sum(CAST(new_cases AS float))*100 as death_percentage
	from covid_deaths
	where continent is not null AND new_cases <>0 

	ORDER BY 1 ,2

	--using temp table to get the percentage of people vacinated every increasing day using temp table
	DROP TABLE IF EXISTS #temp_totalvac;
	create table #temp_totalvac(
	continent varchar(max),
	location varchar(max),
	datee date,
	population bigint,
	new_vac bigint,
	total_vac bigint


	
	)
	insert into #temp_totalvac
	select dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations 
	,sum(cast(isnull(new_vaccinations ,0) as bigint)) over(partition by dea.location order by dea.location, dea.date ) commulative_vac_per_country
	--,(commulative_vac_per_country/population)*100
	from covid_deaths dea
	join covid_VACCINE vac
	on dea.location=vac.location 
	and dea.date=vac.date
	where dea.continent is not null
	order by 2,3



select continent,
location,datee,
population,
new_vac,
total_vac,
(cast(total_vac as float)/cast(population as float))*100 vac_percentage
from #temp_totalvac




	create view percentage_population_vaccinnated as
	select dea.continent,dea.location,dea.date, dea.population,vac.new_vaccinations 
	,sum(cast(isnull(new_vaccinations ,0) as bigint)) over(partition by dea.location order by dea.location, dea.date ) commulative_vac_per_country
	--,(commulative_vac_per_country/population)*100
	from covid_deaths dea
	join covid_VACCINE vac
	on dea.location=vac.location 
	and dea.date=vac.date
	where dea.continent is not null


--Select *
--From CovidDeath
--Order by 3,4

--Select *
--From CovidVaccination
--Order by 3,4

/*-----------------------------------------------------------------------------------------Slect the data that we are going to use------------------------------------------------------------------------------------------------*/

--Select location,date,total_cases,new_cases,total_deaths,population
--From CovidDeath
--Order By 1,2

/*--------------------------------------------------------------------------------------Looking at Total cases Vs Total Deaths------------------------------------------------------------------------------------------------*/

--Select location,date,total_cases,total_deaths, (CONVERT(float, total_deaths) / (CONVERT(float, total_cases)))*100 as DeathPercentage
--From CovidDeath
--Where location like '%states%'
--Order By 1,2

/*---------------------------------------------------------------------------------------Looking at total_cases Vs population------------------------------------------------------------------------------------------------*/
-------------------------------------------------Show what percentage of popuation got covid-------------------------------------------------------------------------

--Select location,date,total_cases,population, (total_cases/population) As percentage of popuation
--From CovidDeath
--Order By 1,2

/*------------------------------------------------------------------------------Countries with highest infection rate compared to population---------------------------------------------------------------------------------------------*/

--Select location,population,MAX(total_cases) As HighestInfectioncount, MAX((total_cases/population))*100 As persent_of_population_infected
--From CovidDeath
--Group By location,population
--Order By persent_of_population_infected DESC

/*---------------------------------------------------------------------------Showing the countries with highest death count per population-------------------------------------------------------------------------------*/

--Select location, Max(total_deaths) as Totaldeathcount
--From CovidDeath
--Where continent is not null
--Group By location
--order by Totaldeathcount desc

/*---------------------------------------------------------------------------Let's breat things down by continent------------------------------------------------------------------------------------------*/

--Select continent, Max(Convert(float,total_deaths)) as Totaldeathcount
--From CovidDeath
--Where continent is not null
--Group By continent
--order by Totaldeathcount desc

--Select location, Max(Convert(float,total_deaths)) as Totaldeathcount
--From CovidDeath
--Where continent is  null
--Group By location
--order by Totaldeathcount desc

/*------------------------------------------------------------------------ Continents with highest death count per population----------------------------------------------------------------------------*/

--Select continent, MAX(total_deaths) as Totaldeathcount
--From CovidDeath
--Where continent is not null
--group by continent
--order by Totaldeathcount desc


/*-----------------------------------------------------------------------------------Global Numbers-----------------------------------------------------------------------------------------------*/

--Select date,SUM(Convert(float,new_cases)) as totalcases,sum(convert(float,new_deaths)) as totaldeaths, sum(convert(float,new_deaths))/sum(convert(float,New_cases)) *100 as deathpercentage
--from CovidDeath
--where continent is not null
--group by date
--order by 1,2


--Select *
--From CovidVaccination

/*------------------------------------------------------------------------------------Join two tables---------------------------------------------------------------------------------------------------*/

--Select *
--From CovidDeath dea
--Join CovidVaccination vac
--on dea.location=vac.location
--and dea.location=vac.location

/*--------------------------------------------------------------------------Total population VS Vaccinations-----------------------------------------------------------------------------------------------------*/

--select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
--, SUM(convert(float,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--from CovidDeath dea
--join CovidVaccination vac
--on dea.location=vac.location
--and dea.date=vac.date
--where dea.continent is not null
----Group by dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
--order by 2,3



/*-----------------------------------------------------------------------------------------------use CTE-----------------------------------------------------------------------------------------------------------------*/

--with popVSvac(Continent,location,date,population,new_vaccinations,RollingPeopleVaccinated) as
--(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
--, SUM(convert(float,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--from CovidDeath dea
--join CovidVaccination vac
--on dea.location=vac.location
--and dea.date=vac.date
--where dea.continent is not null
----Group by dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
----order by 2,3
--)
--Select *, (RollingPeopleVaccinated/population)/100
--from popVSvac

/*--------------------------------------------------------------------------------------------------temp table-------------------------------------------------------------------------------------------------------------------*/


--create table #PercentPopulationVaccinated
--(continent nvarchar(255),
--location nvarchar(255),
--date datetime,
--population numeric,
--new_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)

--Insert into #PercentPopulationVaccinated 
--select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
--, SUM(convert(float,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
------, (RollingPeopleVaccinated/population)*100
--from CovidDeath dea
--join CovidVaccination vac
--on dea.location=vac.location
--and dea.date=vac.date
------where dea.continent is not null
------Group by dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
------order by 2,3

--Select *, (RollingPeopleVaccinated/population)/100
--from #PercentPopulationVaccinated

--/*-----------------------------------------------------------------------------------------------Creating view to store data for later visualizations---------------------------------------------------------------------------------------*/

--Create view PercentPopulationVaccinated as
--select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
--, SUM(convert(float,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
----, (RollingPeopleVaccinated/population)*100
--from CovidDeath dea
--join CovidVaccination vac
--on dea.location=vac.location
--and dea.date=vac.date
--where dea.continent is not null
----Group by dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
----order by 2,3


Select *
from PercentPopulationVaccinated
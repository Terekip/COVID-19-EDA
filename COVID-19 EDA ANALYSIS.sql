select*
from ProjectPortfolio..CovidDeaths1$
where continent is not null
order by 3,4

--select*
--from ProjectPortfolio..CovidVaccinations1$
--order by 3,4

select Location, date, total_cases,new_cases,total_deaths,population
from ProjectPortfolio..CovidDeaths1$
order by 1,2

select Location, date, total_cases,total_deaths
from ProjectPortfolio..CovidDeaths1$
order by 1,2

select Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from ProjectPortfolio..CovidDeaths1$
where Location like '%africa%'
order by 1,2

select Location, date, Population, total_cases,(total_cases/Population)*100 as PercentagePopulationInfected
from ProjectPortfolio..CovidDeaths1$
where Location like '%africa%'
order by 1,2

select Location, Population, MAX(total_cases) as HighestInfectionsCount, MAX((total_cases/Population))*100 as PercentagePopulationInfected
from ProjectPortfolio..CovidDeaths1$
--where Location like '%africa%'
where continent is not null
Group by Location, Population
order by PercentagePopulationInfected desc

select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from ProjectPortfolio..CovidDeaths1$
--where Location like '%africa%'
where continent is not null
Group by Location
order by TotalDeathCount desc

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from ProjectPortfolio..CovidDeaths1$
--where Location like '%africa%'
where continent is not null
Group by continent
order by TotalDeathCount desc

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from ProjectPortfolio..CovidDeaths1$
--where Location like '%africa%'
where continent is not null
--group by date
order by 1,2

select*
from ProjectPortfolio..CovidDeaths1$ dea
join ProjectPortfolio..CovidVaccinations1$ vac
     on dea. location = vac. location
	 and dea.date = vac.date

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
from ProjectPortfolio..CovidDeaths1$ dea
join ProjectPortfolio..CovidVaccinations1$ vac
     on dea. location = vac. location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3

--USE CTE

With PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From ProjectPortfolio..CovidDeaths1$ dea
join ProjectPortfolio..CovidVaccinations1$ vac
     on dea. location = vac. location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac
 
 Drop table if exists #PercentPopulationVaccinated
 Create Table #PercentPopulationVaccinated
 (
 continent varchar(255),
 Location varchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From ProjectPortfolio..CovidDeaths1$ dea
join ProjectPortfolio..CovidVaccinations1$ vac
     on dea. location = vac. location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From  #PercentPopulationVaccinated


Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
From ProjectPortfolio..CovidDeaths1$ dea
join ProjectPortfolio..CovidVaccinations1$ vac
     on dea. location = vac. location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select*
From PercentPopulationVaccinated

Create view TotalDeathCount as
select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from ProjectPortfolio..CovidDeaths1$
--where Location like '%africa%'
where continent is not null
Group by Location
--order by TotalDeathCount desc

Create view DeathPercentage as
select Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from ProjectPortfolio..CovidDeaths1$
where Location like '%africa%'
--order by 1,2

Select*
From PercentPopulationVaccinated
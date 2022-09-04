--total cases vs total deaths in Indonesia
Select location , date , total_cases , total_deaths , (total_Cases/total_Deaths)*100 as DeathPercentage
From MyNewPortofolioProject..CovidDeaths$
where location Like '%indonesia%'
Order by 1,2

--Total Cases vs Population in Indonesia
select location , date , total_cases , Population , (Total_cases/Population)*100 as PopulationPercentage
From MyNewPortofolioProject..CovidDeaths$
where location Like '%indonesia%'
Order by 1,2

-- Which Country with highest infection rate compared to population
select location , MAX(total_cases) as HighestInfectionCount , Population , max((Total_cases/Population))*100 as PercentPopulationInfected
From MyNewPortofolioProject..CovidDeaths$
where continent is not null
Group By location , population
Order by PercentPopulationInfected desc

--Which Country with highest Deaths Count per population
select location , MAX(cast(total_Deaths as int)) as Totaldeathcount
from MyNewPortofolioProject..CovidDeaths$
where continent is not null
Group By Location
Order by Totaldeathcount desc

--Which Continent who has the highest death count per population
select continent , MAX(cast(total_Deaths as int)) as Totaldeathcount
from MyNewPortofolioProject..CovidDeaths$
where continent is not null
Group By Continent
Order by Totaldeathcount desc

--Covid19 distribution on 2020
Select Date , new_cases
From MyNewPortofolioProject..CovidDeaths$

--Global Numbers
Select sum(new_cases) as total_cases , sum(cast(new_deaths as int)) as total_deaths , sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From MyNewPortofolioProject..CovidDeaths$
where continent is not null
order by 1,2

--MERGING 2 TABLE
--From MyNewPortofolioProject..CovidDeaths$ dea
--join MyNewPortofolioProject..CovidVaccinations$ vac
--on dea.location = vac.location
--and dea.date = vac.date

--Looking at total population vs vaccinations
Select Dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations
,Sum(convert(int , vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
From MyNewPortofolioProject..CovidDeaths$ dea
join MyNewPortofolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

--TEMP TABLE
drop table if exists #percentpopulationvaccinated
 Create Table #percentpopulationvaccinated
 (
 Continent nvarchar (255) ,
 location nvarchar (255) ,
 date datetime ,
 population numeric , 
 new_vaccinations numeric ,
 RollingPeopleVaccinated numeric
)

 insert into #percentpopulationvaccinated
 Select Dea.continent , dea.location , dea.date , dea.population , vac.new_vaccinations
,Sum(convert(int , vac.new_vaccinations)) over (partition by dea.location order by dea.location , dea.date) as RollingPeopleVaccinated
From MyNewPortofolioProject..CovidDeaths$ dea
join MyNewPortofolioProject..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select * , (RollingPeopleVaccinated/population)*100
from  #percentpopulationvaccinated


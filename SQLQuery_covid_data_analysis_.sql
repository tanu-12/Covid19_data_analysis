select location ,date,total_cases,new_cases,total_deaths ,population
from PortfolioProject..CovidDeaths
order by 1,2;

--Looking at the total_cases vs total_deaths
select location ,date,total_cases,total_deaths ,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%India%'

order by DeathPercentage desc

select location,population,max(total_cases) as highestcases ,max((total_cases/population)*100) as InfectionPercentage
from PortfolioProject..CovidDeaths
group by location,population
order by InfectionPercentage desc

--countries with highest death count

select location,max(cast(total_deaths as int)) as highestDeaths 
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by highestDeaths desc


--global numbers

select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases) *100
from PortfolioProject..CovidDeaths
where continent is not null

--looking at data on total population vs vaccination need to join table for this 

select dea.location, dea.date, dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as rollingPeopleVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location AND 
dea.date=vac.date
order by dea.location,dea.date

--use cte

With PopvsVac (location, date, population,new_vaccinations,rollingPeopleVaccination)
as
(select dea.location, dea.date, dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as rollingPeopleVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location AND 
dea.date=vac.date)
select  *,(rollingPeopleVaccination/population)*100
--where new_vaccinations is not null   
from PopvsVac

Create View PercentPopulationVaccinations
as 
select dea.location, dea.date, dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as rollingPeopleVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location AND 
dea.date=vac.date


--Test
Select Location, date, total_cases, new_cases, total_deaths, population
From dbo.CovidDeaths
order by 1,2

--Calculating the death percentage from covid in Canada
Select Location, date, total_cases, total_deaths, ((Cast(total_deaths as Float)/Cast(total_cases as float))*100) as DeathPerc
From dbo.CovidDeaths
Where location like 'Canada'
Where continent is not Null
order by 1,2

--What percentage of the population got infected with Covid in Canada
Select Location, date, total_cases, total_deaths, ((Cast(total_cases as Float)/Cast(population as float))*100) as InfectionRate
From dbo.CovidDeaths
Where location like 'Canada'
Where continent is not Null
order by 1,2

--Finding the countries with Highest Infection rate compared to Population
Select Location, Population, MAX(total_cases) as MaxInfectionCount, MAX((Cast(total_cases as Float)/Cast(population as float))*100) as MaxInfectionRate
From dbo.CovidDeaths
Where continent is not Null
Group by Location, Population
order by MaxInfectionCount DESC

--Finding the countries with the highest Death Count comapred to population
SELECT Location, Max(total_deaths) as MaxTotalDeaths
From dbo.CovidDeaths
Where continent is not Null
Group by Location
order by MaxTotalDeaths DESC


--Find the total cases and total deaths by date in the world
Select  date, Sum(new_cases) as TotalCases, Sum(new_deaths) as TotalDeaths, Sum(Cast(new_deaths as float))/Sum(Cast(new_cases as float))*100 as DeathPercentage
From dbo.CovidDeaths
Where continent is not Null
Group by date
order by 1,2


--Join Vaccination table

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
    On dea.location=vac.location
    and dea.date=vac.date
Where dea.continent is not null
order by 1,2,3

--Total population vs vaccinations using partitions
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(vac.new_vaccinations) Over (Partition by dea.location Order by dea.location, dea.date) as PeopleVaccinatedAtm
From dbo.CovidDeaths dea
Join dbo.CovidVaccinations vac
    On dea.location=vac.location
    and dea.date=vac.date
Where dea.continent is not null
order by 1,2,3


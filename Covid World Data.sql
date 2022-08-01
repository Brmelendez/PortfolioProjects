Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

Select *
From PortfolioProject..CovidVaccinations
order by 3,4
--Now lets select the data we are using

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2


--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
Where Location = 'United States'
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid

Select Location, date, total_cases, population, (total_deaths/population)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
Where Location = 'United States'
order by 1,2

--Looking at Countries with highest infection rate compared to population

Select Location, population, Max(total_cases) as Highest_Infection_Count, Max((total_cases/population))*100 as Percent_Population_Infected
From PortfolioProject..CovidDeaths
--Where Location = 'United States'
Group by Location, population
order by Percent_Population_Infected desc

--Showing Countires with the highest death count per population

Select Location, Max(cast (total_deaths as int)) as Total_Death_Count
From PortfolioProject..CovidDeaths
--Where Location = 'United States'
Where continent is not null
Group by Location
Order by Total_Death_Count desc

--Showing the continent witht the highest death count

Select continent, Max(cast (total_deaths as int)) as Total_Death_Count
From PortfolioProject..CovidDeaths
--Where Location = 'United States'
Where continent is not null
Group by continent
Order by Total_Death_Count desc

--Global Numbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths
, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
--Where location = 'United Sates'
Where continent is not null
--Group by date
Order by 1,2


Select *
From PortfolioProject..CovidDeaths
Join PortfolioProject..CovidVaccinations
	On CovidDeaths.location = CovidVaccinations.location
	and CovidDeaths.date = CovidVaccinations.date

--Looking at total population vs vaccination
--Use CTE

With PopvsVac(Continent, Location, date, population, new_vaccinations, Rolling_People_Vaccinated)
as
(
Select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations
, SUM(cast(CovidVaccinations.new_vaccinations as bigint)) OVER (Partition by CovidDeaths.Location Order by CovidDeaths.location,
CovidDeaths.date) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/population)*100
From PortfolioProject..CovidDeaths
Join PortfolioProject..CovidVaccinations
	On CovidDeaths.location = CovidVaccinations.location
	and CovidDeaths.date = CovidVaccinations.date
Where CovidDeaths.continent is not null
--order by 2,3
)

Select *, (Rolling_People_Vaccinated/population)*100 as Population_Vaccinated
From PopvsVac


--Temp Table

DROP Table if exists #Percent_Population_Vaccinated

Create Table #Percent_Population_Vaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
Rolling_People_Vaccinated numeric
)

Insert into #Percent_Population_Vaccinated
Select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations
, SUM(cast(CovidVaccinations.new_vaccinations as bigint)) OVER (Partition by CovidDeaths.Location Order by CovidDeaths.location,
CovidDeaths.date) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/population)*100
From PortfolioProject..CovidDeaths
Join PortfolioProject..CovidVaccinations
	On CovidDeaths.location = CovidVaccinations.location
	and CovidDeaths.date = CovidVaccinations.date
Where CovidDeaths.continent is not null
--order by 2,3

Select *, (Rolling_People_Vaccinated/population)*100 as Percent_Population_Vaccinated
From #Percent_Population_Vaccinated

--Creating view to store data for later visualization

Create View Percent_Population_Vaccinate as
Select CovidDeaths.continent, CovidDeaths.location, CovidDeaths.date, CovidDeaths.population, CovidVaccinations.new_vaccinations
, SUM(cast(CovidVaccinations.new_vaccinations as bigint)) OVER (Partition by CovidDeaths.Location Order by CovidDeaths.location,
CovidDeaths.date) as Rolling_People_Vaccinated
--, (Rolling_People_Vaccinated/population)*100
From PortfolioProject..CovidDeaths
Join PortfolioProject..CovidVaccinations
	On CovidDeaths.location = CovidVaccinations.location
	and CovidDeaths.date = CovidVaccinations.date
Where CovidDeaths.continent is not null
--order by 2,3

Create View Total_Deaths_US as
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From PortfolioProject..CovidDeaths
Where Location = 'United States'
--order by 1,2
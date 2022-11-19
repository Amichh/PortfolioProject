Select *
From .CovidDeaths


--The probablity of dying by covid infection in countires
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Case_fatality_rate_in_your_country
From .CovidDeaths
Where continent is not Null
Order by 1,2

--the percent of populaton infected by covid in your country
Select location,date,total_cases,population,(total_cases/population)*100 as PercentofInfected_population
From .CovidDeaths
Where continent is not Null
Order by 1,2
--countires with highest population rate
Select Location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as PercentofInfected_population
From .CovidDeaths
Where continent is not Null
Group by location,population
Order by 1,2

--countries with highest death count perpopulation

Select location,MAX(cast(total_deaths as int)) as TotalDeathcount
From.CovidDeaths
Where continent is not Null
Group by location
Order by TotalDeathCount desc

--Continent with highest death rate

Select location,MAX(cast(total_deaths as int)) as TotalDeathcount
From.CovidDeaths
Where continent is  Null
Group by location
Order by TotalDeathCount desc
-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join .CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Creating View to store data for later visualizations
GO
Create View Vaccinated_Population_ as  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
 --,(RollingPeopleVaccinated/population)*100 as percent_Population_Vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 



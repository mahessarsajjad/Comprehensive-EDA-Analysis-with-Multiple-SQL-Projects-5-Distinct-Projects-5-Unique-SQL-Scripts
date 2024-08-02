SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percentage
FROM "CovidDeaths MySQL" 
ORDER BY 1,2;

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS 
FROM "CovidDeaths MySQL" 
WHERE location LIKE '%states';


-- Showing Countries with Highest Death Count per Population

SELECT 
    Location, Population, MAX(cast(Total_deaths as int)) AS highestInfectionCount, MAX(total_cases/population)*100 AS PercentPopulationInfected 
FROM 
	"CovidDeaths MySQL" 
GROUP BY 
    Location, 
    Population
ORDER BY 
    PercentPopulationInfected DESC;

   
SELECT 
    Location, MAX((CAST Total_deaths as int)) AS totaldeathcount
FROM 
	"CovidDeaths MySQL" 
GROUP BY 
    Location
ORDER BY 
    TotalDeathCount DESC;
   
   -- LETS BREAK THINGS BY CONTINTENT
SELECT 
    CONTINENT, MAX((CAST Total_deaths AS int)) AS totaldeathcount
FROM 
	"CovidDeaths MySQL" 
GROUP BY 
    Continent
ORDER BY 
    TotalDeathCount DESC;   
    
   
   
   
-- Showing the continents with the highest death count per population
   
SELECT continent, MAX(cast(Total_deaths AS int)) as Total_death_count
FROM "CovidDeaths MySQL" 
WHERE continent IS NOT NULL 
GROUP BY continent 
ORDER BY total_death_count DESC;


-- GLOBAL NUMBERS 

SELECT date, SUM(new_cases) AS total_cases2. SUM(cast(new_deaths as int)) AS total_deaths2,  SUM(cast(new_deaths as int))/SUM(new_Cases)*100 AS deathPercentage
FROM "CovidDeaths MySQL" 
WHERE CONTINENT IS NOT NULL
GROUP BY date
ORDER BY 1,2;


-- Working on explording data in CovidVaccinations File

SELECT * 
FROM "CovidVaccinations MySQL";

-- Looking at total population vs vaccination
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
FROM "CovidDeaths MySQL" AS dea
JOIN "CovidVaccinations MySQL" AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date;
order by 1,2,3;	


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int) OVER (PARTITION BY dea.location ORDER BY dea.location, dea/date) AS RollingPeopleVaccinated
, (RollingPeopleVaccinated/Population)*100
FROM "CovidDeaths MySQL" AS dea
JOIN "CovidVaccinations MySQL" AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date;
order by 2,3	

-- USE CTE
WITH PopvsVac (Continent, Location, Date, Population, New_vaccinations, Rolling People Vaccinated)

AS 

(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int) OVER (PARTITION BY dea.location ORDER BY dea.location, dea/date) AS RollingPeopleVaccinated
, (RollingPeopleVaccinated/Population)*100
FROM "CovidDeaths MySQL" AS dea
JOIN "CovidVaccinations MySQL" AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	)
SELECT *, (RollingPeopleVaccinated/Population)
FROM PopvsVac;


-- TEMP TABLE
DROP TABLE if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated numeric)


INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int) OVER (PARTITION BY dea.location ORDER BY dea.location, dea/date) AS RollingPeopleVaccinated
, (RollingPeopleVaccinated/Population)*100
FROM "CovidDeaths MySQL" AS dea
JOIN "CovidVaccinations MySQL" AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	
	
SELECT *, (RollingPeopleVaccinated/Population)
FROM #PercentPopulationVaccinated

	
	
-- Create view to store data for later visualisations 
Create view PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CAST(vac.new_vaccinations as int) OVER (PARTITION BY dea.location ORDER BY dea.location, dea/date) AS RollingPeopleVaccinated
, (RollingPeopleVaccinated/Population)*100
FROM "CovidDeaths MySQL" AS dea
JOIN "CovidVaccinations MySQL" AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL;


SELECT * 
FROM PercentPopulationVaccinated







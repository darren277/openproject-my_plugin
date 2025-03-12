# OpenProject My Plugin

A plugin for OpenProject that adds gamification and KPI dashboard features.

## Features

### Gamification System

The gamification system rewards users for completing tasks and contributing to projects:

- **Experience Points**: Earn XP for completing work packages, reviewing code, fixing bugs, etc.
- **Levels and Ranks**: Progress through levels and earn prestigious ranks
- **Achievements**: Unlock special achievements for completing specific goals
- **Leaderboard**: Compete with colleagues on weekly, monthly, and all-time leaderboards
- **Profile Page**: View your personal gamification profile with stats and achievements

### KPI Dashboard

Track important project metrics in one place:

- Visualize task completion rates
- Monitor team performance
- Track progress towards project goals
- Analyze trends over time

## Installation

### Prerequisites

This plugin requires:
- OpenProject 12.0.0 or higher
- Ruby 3.0 or higher
- Bundler

### Steps

1. Clone the repository into the plugins directory:
   ```bash
   cd openproject/plugins
   git clone https://github.com/darren277/openproject-my_plugin.git
   ```

2. Install the plugin:
   ```bash
   cd openproject
   bundle install
   ```

3. Run the plugin migrations:
   ```bash
   bundle exec rake my_plugin:install:migrations
   ```

4. Seed the initial achievements:
   ```bash
   bundle exec rake my_plugin:seed
   ```

5. Bundle plugin assets:
   ```bash
   # From the main OpenProject directory
   bundle exec rake my_plugin:precompile_assets
   ```

6. Restart your OpenProject server

## Usage

### Gamification

- Access the gamification system from the top menu "Gamification"
- View your personal profile at "My Profile" in the account menu
- Check the leaderboard to see top performers
- View available achievements and your progress
- Complete tasks to earn XP and unlock achievements

### KPI Dashboard

- Access the KPI Dashboard from the project menu
- View performance metrics for your project
- Filter data by time period or work package type
- Export reports as needed

## Configuration

You can configure the plugin in Administration > OpenProject Plugins > My Plugin:

- Enable/disable specific features
- Adjust XP values for different actions
- Configure achievement criteria
- Customize KPI dashboard metrics

## Development

### Running Tests

```bash
bundle exec rake test:plugins:all RAILS_ENV=test
```

### Adding New Achievements

To add new achievements, create a new migration:

```bash
bundle exec rails generate open_project_plugin_migration my_plugin AddNewAchievements
```

Then define your achievements in the migration file.

## License

This plugin is licensed under the GNU GPL v3. See LICENSE for details.

## Support

For questions or issues, please:
- Open an issue on GitHub
- Contact the author at darren277@yahoo.com

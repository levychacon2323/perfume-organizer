# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial project setup with Expo SDK 54 and Expo Router
- Offline-first database with expo-sqlite + Drizzle ORM
- `perfumes` table with full schema (catalog fields, ownership, metadata, soft delete)
- Database migrations with `useDatabaseMigrations` hook integrated into root layout
- NativeWind v4 for styling with custom theme tokens (colors, typography, border radius)
- Stack: Zustand, TanStack Query, react-hook-form, zod, Fuse.js, date-fns
- Feature-based architecture under `src/features/`
- `db:generate` and `db:studio` npm scripts for Drizzle workflow

[Unreleased]: https://github.com/levychacon23/perfume-organizer/compare/HEAD...HEAD

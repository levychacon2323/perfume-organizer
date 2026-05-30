import { sql } from 'drizzle-orm';
import { sqliteTable, text, integer, real } from 'drizzle-orm/sqlite-core';

export const perfumes = sqliteTable('perfumes', {
  id: text('id').primaryKey(),

  catalogId: text('catalog_id'),
  name: text('name').notNull(),
  brand: text('brand').notNull(),
  line: text('line'),
  concentration: text('concentration', {
    enum: ['EDC', 'EDT', 'EDP', 'Parfum', 'Extrait'],
  }).notNull(),
  year: integer('year'),
  gender: text('gender', {
    enum: ['masculine', 'feminine', 'unisex'],
  }).notNull(),
  family: text('family'),

  bottleSizeMl: integer('bottle_size_ml'),
  fillLevel: real('fill_level').notNull().default(100),
  batchCode: text('batch_code'),

  purchasedAt: integer('purchased_at', { mode: 'timestamp_ms' }),
  purchasePrice: real('purchase_price'),
  purchaseCurrency: text('purchase_currency'),
  purchaseLocation: text('purchase_location'),
  isGift: integer('is_gift', { mode: 'boolean' }).notNull().default(false),

  rating: real('rating'),
  isFavorite: integer('is_favorite', { mode: 'boolean' }).notNull().default(false),
  status: text('status', {
    enum: ['owned', 'sold', 'gifted', 'empty', 'decanted'],
  }).notNull().default('owned'),
  notes: text('notes'),

  createdAt: integer('created_at', { mode: 'timestamp_ms' })
    .notNull()
    .default(sql`(unixepoch() * 1000)`),
  updatedAt: integer('updated_at', { mode: 'timestamp_ms' })
    .notNull()
    .default(sql`(unixepoch() * 1000)`),
  deletedAt: integer('deleted_at', { mode: 'timestamp_ms' }),
});

export type Perfume = typeof perfumes.$inferSelect;
export type NewPerfume = typeof perfumes.$inferInsert;

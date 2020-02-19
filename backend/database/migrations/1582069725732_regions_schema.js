'use strict'

/** @type {import('@adonisjs/lucid/src/Schema')} */
const Schema = use('Schema')

class RegionsSchema extends Schema {
  up () {
    this.create('regions', (table) => {
      table.increments()
      table.string('name').notNullable()
      table.float('latitude', 14, 10).notNullable()
      table.float('longitude', 14, 10).notNullable()
      table.float('latitudeDelta', 14, 10).notNullable()
      table.float('longitudeDelta', 14, 10).notNullable()
      table.timestamps()
    })
  }

  down () {
    this.drop('regions')
  }
}

module.exports = RegionsSchema

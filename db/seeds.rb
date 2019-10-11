# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Incident.__elasticsearch__.create_index!(force: true)

reporter_1 = Reporter.create!(name: 'Efe Agare', email: 'efe.agare@mail.com', password: 'password')
reporter_2 = Reporter.create!(name: 'Ibidapo Rasheed', email: 'ibidapo.rasheed@mail.com', password: 'password')

Incident.create!(title: 'Xenephobia', location: 'South Africa', narration: 'Xenephobic attacks in SA', status: 'investigating', evidence: 'nothing yet', reporter_id: reporter_1.id, incident_type_id: 1)
Incident.create!(title: 'Xenephobia', location: 'Nigeria', narration: 'Retaliation to Xenephobic attacks in SA', status: 'investigating', evidence: 'nothing yet', reporter_id: reporter_1.id, incident_type_id: 2)
Incident.create!(title: 'Xenephobia', location: 'South Africa', narration: 'Xenephobic attacks in SA', status: 'investigating', evidence: 'nothing yet', reporter_id: reporter_2.id, incident_type_id: 1)
Incident.create!(title: 'Xenephobia', location: 'Nigeria', narration: 'Retaliation to Xenephobic attacks in SA', status: 'investigating', evidence: 'nothing yet', reporter_id: reporter_2.id, incident_type_id: 2)

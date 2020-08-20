company = Company.create!(name: "TakeOne Productions")
project = Project.create!([{ name: "Galaxy Wars", company: company }, { name: "BlueDay Music Video", company:company }])
user = User.create!(name: "Jeff Lucas", email: "jeff@test.host")

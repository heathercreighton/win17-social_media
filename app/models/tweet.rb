class Tweet < ApplicationRecord

	belongs_to :user

	has_many :tweet_tags
	has_many :tags, through: :tweet_tags

	before_validation :link_check, on: :create

	validates :message, presence: true, length: {maximum: 140, too_long: "A tweet can only be 140 characters!"}, on: :create
	after_validation :apply_link, on: :create

	private

	def link_check
		check = false

		if self.message.include?("http")
			check = true
		end
		
		if check == true
			arr = self.message.split
			index = arr.map{ |x| x.include?("http")}.index(true)
			self.link = arr[index]

			puts "-----------------------"
			puts self.link
			puts "-----------------------"

			if arr[index].length > 23
				arr[index] = "#{arr[index][0..20]}..."
			end
			
			self.message = arr.join(" ")	
		end

		def apply_link
			arr = self.message.split
			index = arr.map{ |x| x.include?("http")}.index(true)

			if index
				url = arr[index]
				arr[index] = "<a href='#{self.link}' target='_blank'>#{url}</a>"
			end



			self.message = arr.join(" ")	
		end	
	end	





end

class Movie < ActiveRecord::Base

	def self.all_ratings
		['G','PG','PG-13','R']
	end

	def self.with_ratings(ratings_list, order)
		if ratings_list==nil
			if order == "release_date"
				all.order(:release_date)
			elsif order == "title"
				all.order(:title)
			else
				all
			end	
				
		else
			if order == "release_date"
				self.where(rating: ratings_list.keys).order(:release_date)
			elsif order == "title"
				self.where(rating: ratings_list.keys).order(:title)
			else				
				self.where(rating: ratings_list.keys)
			end
		end
	end
end

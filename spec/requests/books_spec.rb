require 'rails_helper'

describe 'Books API', type: :request do
	let(:author1) { FactoryBot.create(:author, first_name: 'George', last_name: 'Orwell')}
	let(:author2) { FactoryBot.create(:author, first_name: 'Frank ', last_name: 'Herbert')}

	describe 'GET /books' do
		before do
			book1 = FactoryBot.create(:book, title: '1984', author: author1)
			book2 = FactoryBot.create(:book, title: 'Dune', author: author2)
		end

		it 'returns all books' do
			get '/api/v1/books'
	
			expect(response).to have_http_status(:success)
			expect(response.body.size).to eq(2)
			expect(response.body, symbolize_names: true).to eq(
				[
					{
						'id':  book1.id,
						'title': book1.title,
						'author_name': book1.author
					},
					{
						'id': book2.id,
						'title': book2.title,
						'author_name': book2.author
					}
				]

			)
		end
	end

	describe 'POST /books' do
		before do
			let(:book) { FactoryBot.create(:book, title: '1984', author: author1) }
		end

		it 'creates a new book' do
			expect {
				post '/api/v1/books', params: { 
					book: {title: 'The Martian'}, 
					author: { first_name: 'Andy', last_name: 'Weir'} 
				}
			}.to change { Book.count }.by(1)

			expect(response).to respond_with_content_type(:json)
			expect(response.body, symbolize_names: true).to eq(
				'id': book.id,
				'title': 'The Martian',
				'author_name': "Andy Weir"
			)
		end
		 
		it 'returns http created' do
			expect(response).to have_http_status(:created)
		end

		it 'response contains expected Book attributes' do

			expect { hash_body = response.body.with_indifferent_access }.not_to raise_exception
      expect(hash_body.keys).to match_array([:id, :author, :title])
			expect(hash_body).to match({
        id: article.id,
        title: 'The Martian'
      })
		end
	end

	describe 'DELETE /books/:id' do
		let!(:book) { FactoryBot.create(:book, title: 'Dune', author: author2 )	}	
		
		it 'deletes a book' do
			expect {
				delete "/api/v1/books/#{book.id}"
			}.to change { Book.count }.by(-1)

			expect(response).to have_http_status(:no_content)
		end
	end
	

end
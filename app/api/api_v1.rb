class API_v1 < Grape::API
  version 'v1', using: :path, format: :json, vendor: 'hummingbird'

  before do
    @start_time = Time.now
  end
  
  after do
    @end_time = Time.now
    lat = (@end_time - @start_time).to_f
    $riemann << {
      service: "api req",
      metric: lat,
      state: "ok"
    }
  end
  
  resource :anime do
    desc "Return an anime"
    params do
      requires :id, type: String, desc: "anime ID"
    end
    get ':id' do
      anime = Anime.find(params[:id])
      {title: anime.canonical_title, alternate_title: anime.alternate_title, url: anime_url(anime)}
    end
    
    desc "Returns similar anime."
    params do
      requires :id, type: String, desc: "anime ID"
      optional :limit, type: Integer, desc: "number of results (max/default 20)"
    end
    get ':id/similar' do
      anime = Anime.find(params[:id])
      similar_anime = []
      similar_json = JSON.load(open("http://app.vikhyat.net/anime_safari/related/#{anime.mal_id}"))
      similar_json = similar_json[0..(params[:limit]-1)] if similar_json.length > params[:limit]
      similar_json.each do |similar|
        sim = Anime.find_by_mal_id(similar["id"])
        similar_anime.push(sim) if sim
      end
      similar_anime.map {|x| {id: x.slug, title: x.canonical_title, alternate_title: x.alternate_title, genres: x.genres.map {|x| x.name }, cover_image_url: x.cover_image.url} }
    end
  end
end
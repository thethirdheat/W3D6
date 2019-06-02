# == Schema Information
#
# Table name: actors
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: movies
#
#  id          :integer      not null, primary key
#  title       :string
#  yr          :integer
#  score       :float
#  votes       :integer
#  director_id :integer
#
# Table name: castings
#
#  movie_id    :integer      not null, primary key
#  actor_id    :integer      not null, primary key
#  ord         :integer

require_relative './sqlzoo.rb'

def example_join
  execute(<<-SQL)
    SELECT
      *
    FROM
      movies
    JOIN
      castings ON movies.id = castings.movie_id
    JOIN
      actors ON castings.actor_id = actors.id
    WHERE
      actors.name = 'Sean Connery'
  SQL
end

def ford_films
  # List the films in which 'Harrison Ford' has appeared.
  execute(<<-SQL)
    select movies.title
    from movies 
    join castings on castings.movie_id = movies.id
    join actors on castings.actor_id = actors.id
    where actors.name ='Harrison Ford'
  SQL
end

def ford_supporting_films
  # List the films where 'Harrison Ford' has appeared - but not in the star
  # role. [Note: the ord field of casting gives the position of the actor. If
  # ord=1 then this actor is in the starring role]
  execute(<<-SQL) 
    select movies.title
    from movies
    join castings on castings.movie_id=movies.id
    join actors on castings.actor_id=actors.id
    where actors.name='Harrison Ford' and ord!=1
  SQL
end

def films_and_stars_from_sixty_two
  # List the title and leading star of every 1962 film.
  execute(<<-SQL)
    select movies.title, actors.name
    from movies
    join castings on castings.movie_id=movies.id
    join actors on actors.id=castings.actor_id
    where movies.yr=1962 and castings.ord=1
  SQL
end

def travoltas_busiest_years
  # Which were the busiest years for 'John Travolta'? Show the year and the
  # number of movies he made for any year in which he made at least 2 movies.
  execute(<<-SQL)
    select yr, count(title)
    from movies
    join castings on castings.movie_id=movies.id
    join actors on actors.id=castings.actor_id 
    where name='John Travolta'
    group by movies.yr
    having count(*) >=2
  SQL
end

def andrews_films_and_leads
  # List the film title and the leading actor for all of the films 'Julie 
  # Andrews' played in.

 # execute(<<-SQL)
 #   select movies.title, actors.name
 #   from movies
 #   join castings on castings.movie_id=movies.id
 #   join actors on actors.id=castings.actor_id 
 #   where actors.name= 'Julie Andrews'
 #   group by actors.name
 #   having castings.ord=1
 # SQL
  execute(<<-SQL)
    select movies.title, lead_act.name
    from movies
    join castings julie_mov on julie_mov.movie_id=movies.id
    join actors julie_act on julie_mov.actor_id=julie_act.id

    join castings lead_cast on lead_cast.movie_id=movies.id
    join actors lead_act on lead_cast.actor_id=lead_act.id

    where julie_act.name='Julie Andrews' and lead_cast.ord=1
  SQL
end

def prolific_actors
  # Obtain a list in alphabetical order of actors who've had at least 15
  # starring roles.
  execute(<<-SQL) 
    select actors.name
    from actors
    join castings on castings.actor_id = actors.id
    where castings.ord=1
    group by actors.name
    having count(*) >=15
    order by actors.name
  SQL
    #join movie lul on mov_all.movie_id = movies.id
end

def films_by_cast_size
  # List the films released in the year 1978 ordered by the number of actors
  # in the cast (descending), then by title (ascending).
  execute(<<-SQL)
    select movies.title, count(distinct castings.actor_id) as actor_count
    from movies
    join castings on castings.movie_id=movies.id
    where movies.yr= 1978
    group by movies.id
    order by count(*) desc, movies.title asc 
  SQL
end

def colleagues_of_garfunkel
  # List all the people who have played alongside 'Art Garfunkel'.
  execute(<<-SQL) 
    select Without_art.name
    from (
      select movies.*
      from movies
      join castings on castings.movie_id = movies.id
      join actors on actors.id= castings.actor_id
      where name = 'Art Garfunkel'
    ) as T1
    join (
      select actors.*, castings.movie_id
      from actors
      join castings on castings.actor_id = actors.id
      where name!='Art Garfunkel'
    ) as Without_Art on T1.id=Without_art.movie_id

  SQL
#  execute(<<-SQL) 
#    select a1.name 
#    from (
#      select movies.*
#      from movies
#      join castings on castings.movie_id=movies.id
#      join actors on actors.id=castings.actor_id
#      where actors.name='Art Garfunkel'
#    ) as m1 
#    join (
#      select actors.* , castings.movie_id
#      from actors 
#      join castings on castings.actor_id = actors.id
#      where actors.name != 'Art Garfunkel'
#    ) as a1 on  m1.id=a1.movie_id 
#  SQL
#  execute(<<-SQL) 
#    select all_without_art.name
#    from (
#      select movies.*
#      from movies
#      join castings on castings.movie_id=movies.id
#      join actors on actors.id= castings.actor_id
#      where  actors.name= 'Art Garfunkel') as all_with_art
#    join ( select castings.movie_id
#      from movies
#      join castings on castings.movie_id=movies.id
#      join actors on actors.id= castings.actor_id
#      where  actors.name!='Art Garfunkel') as all_without_art 
#      on all_with_art.id=all_without_art.movie_id
#  SQL
end

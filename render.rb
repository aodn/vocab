
# Usage
# ruby render.rb  -t templates/skos1.erb  | less


require 'erb'
require 'pg'
require 'optparse'


def map_query( conn, query, args, &code )
  # map a proc/block over postgres query result
  xs = []
  conn.exec( query, args ).each do |row|
    xs << code.call( row )
  end
  xs
end


class RDFBinding

  include ERB::Util
#  attr_accessor  :template, :date

  def initialize( conn, date)
    @conn = conn
    @date = date
  end

  # we are going to need a more general sql, to limit everything
  # to the general parameter scheme

  def query_rdf_objects( predicate, subject )
    map_query( @conn, 'select object from _rdf where predicate = $1 and subject = $2',
    [predicate, subject]) do |row|
      row['object']
    end
  end

  def query_rdf_subjects( predicate, object )
    map_query( @conn, 'select subject from _rdf where predicate = $1 and object = $2',
    [predicate, object]) do |row|
      row['subject']
    end
  end


  ### actually we shouldn't be passing os, we should be instead passing
  ### the template

  # we should pass the file name here... 
	# to make it easier for nested templates to work

  def render( filename  )
	# we pass the file name here, rather than an open stream here or in the 
	# destructor to make it easier 

	
	t = File.read( filename )
    s = ERB.new( t).result(binding)

    # s = ERB.new(@template, nil, '>').result(binding)
    s = s.gsub /^[ \t]*$\n/, ''
    puts s
  end

end



options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  opts.on('-t', '--templatefile NAME', 'templatefile') { |v| options[:template_file] = v }
end.parse!
if options[:template_file]

  conn = PG::Connection.open(
    :host => '127.0.0.1',   # options[:dbhost] || '127.0.0.1'  etc
    :dbname => 'vocab',
    :user => 'contr_vocab_db',
    :password => 'contr_vocab_db'
  )

  #list = RDFBinding.new( File.read('skos1.erb') )
  list = RDFBinding.new( conn, Time.now )
  list.render( options[:template_file] )
else
  puts 'no file specified!'

end




#
# 	# the question is do we want to build an intermediate data structure, or else just execute
# 	# if we use map easily then we ought to be able to do it.
#
# #	@rows = conn.exec('select * from _rdf where predicate = $$rdf:type$$ ', ['http://vocab.aodn.org.au/def/ClassScheme/platform1/Category/'])
#
# 	# now we need dc title
#
# 	# we don't want prepared
#
# 	# so we can loop this stuff, herre to build up the model...
# 	# or else create the predicate
#
# 	# we're building up a tree- graph. which is kind of crap.
#
# 	# we're going to build  a data structure
#
# 	@conceptSchemes = @conn.exec('select * from _rdf where predicate = $$rdf:type$$ and object = $$skos:ConceptScheme$$' )
#
# 	@dc_titles = @conn.exec('select * from _rdf where predicate = $$dc:title$$' )
#
# 	@dc_descriptions = @conn.exec('select * from _rdf where predicate = $$dc:description$$' )
#
#
# 	puts "*** here #{ @dc_titles[0]['subject'] } "
#
#
#
# 	# how can we do a map?
#
# # 	@conn.exec('select * from _rdf where predicate = $$rdf:type$$ and object = $$skos:ConceptScheme$$' ).each do |j|
# #
# # 		puts "-> #{j['subject']}"
# #
# # 	end
# #
# 	puts "***********\nhere"
#
# 	j = mapquery( @conn, 'select * from _rdf where predicate = $$rdf:type$$ and object = $$skos:ConceptScheme$$', nil) do |x|
#
# 		conceptScheme = { }
# 		conceptScheme['subject'] = x
#
# 		# dc_title = @conn.exec('select * from _rdf where predicate = $$dc:title$$ and subject = $1', [conceptScheme] )
#
# 		conceptScheme['dc_term'] = mapquery( @conn, 'select object from _rdf where predicate = $$dc:title$$ and subject = $1',
# 			[conceptScheme['subject']]) do |u| u end
#
#
# 	end
#
# 	puts j
#
	#abort()
	# we can build the graph in the template ??
	# or in the other class

	# Ok, we could actually just index everything ... in the template.
	# in fact we have to do it this way.
	# the loop is in the template. so we need to build everything from there...

	# pass the connection into the template - or build a tree



#		rdf:type       | skos:ConceptScheme

	# ok, we can index like this.
	# but it's not clear
#	puts @rows[0]['subject']

# 	# we want to map to ruby objects, or is it even necessary?
# 	rdf = rows.map do |row|
# 		puts row
# 		{ :x => row['subject'] }
# 	end
#
#
# note that directly embedding the sql would be a bit like sparql
# 		<% for @dc_title in @dc_titles %>
# 			<dc:title> <%= @dc_title['object'] %>   </dc:title> <% end %>
#

#	<li><%= @rows[0]['subject'] %></li>

# ok, i think in the initialize we should set up all the vars
# or else directly embed the sql in the template ?



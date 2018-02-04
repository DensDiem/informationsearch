$num_of_doc = 12
def collection_to_a()

  collection = []
  i = 1
  while i <= $num_of_doc
  filename ="file_"+i.to_s+".txt"
    file = File.new(filename)
    file.each do |line|
      line = line.delete "/?/<!/,— .-»…–№“”"
      line = line.delete '"'
      line = line.delete ")(+-"
      line = line.split
      line = line.split
      j = 0
      while j < line.size
        collection.push( [line[j],i])
        j+=1
      end
    end
    i+=1
  end
  return collection.sort
end
def get_wordbook_txt(wb_name,col)
  f = File.new(wb_name+".txt", 'w')
  f.puts("the total number of words in the collection " + col.size.to_s)
  col = col.uniq
  f.puts("the total number of words in the wordbook " + col.size.to_s)
  f.puts(col)
  f.close
end
#serialization
def get_wordbook_serial(wb_name)
  col = collection_to_a
  f = File.open( wb_name+".sav", 'w' )
  Marshal.dump("the total number of words in the collection " + col.size.to_s, f )
  col = col.uniq
  Marshal.dump("the total number of words in the wordbook " + col.size.to_s, f )
  Marshal.dump(col, f )
  f.close
end

def create_index(collection)
arr_idx = []
arrays = []
i = -1
j = 0
i=i+1
  while i < collection.size
    arrays.push(collection[i][0])
    arrays = arrays.flatten
    while i < collection.size && collection[i][0].eql?(arrays[0])
      arrays.push(collection[i][1])
      i+=1
    end
    arr_idx.push(arrays)
    arrays = []
  end
return arr_idx

end

def create_matrix(indx)
  matrix = []
  arrays = []
  i = 0
  while indx.size > i
    arrays.push indx[i][0]
    j=1
    while j <= $num_of_doc
      if indx[i].include?(j)
        arrays.push(1)
      else
        arrays.push(0)
      end
      j+=1
    end
    matrix.push(arrays)
    arrays = []
    i+=1
  end
  return matrix
end
def check(answer,matrix)
  i = 0
  while i < $num_of_doc
    answer[i] = answer[i]&matrix[i]
    i+=1
  end
  return answer
end
def boolean_search_simple(word, matrix)
  word = word.delete " "
  word = word.split "AND"
  answer = []
  i = 0
  f = true
  while i < $num_of_doc
  answer.push(1);
    i+=1
  end
  j=0
  while j < word.size
  i = 0
  while i < matrix.size
    if matrix[i][0] == word[j]
      f=false
      answer = check(answer,matrix[i][1..$num_of_doc])
    end
    if i == matrix.size && matrix[i][0] == word[j]
      return "not found"
    end
    i+=1

  end
    j+=1
  end
  k=0
  doc = []
if f
  return "not found"
end
  while k < $num_of_doc
    if answer[k] == 1
      doc.push(k+1)
    end
    k+=1
  end
     return doc

end
def collection_to_two_word()

  collection = []
  i = 1
  while i <= $num_of_doc
    filename ="file_"+i.to_s+".txt"
    file = File.new(filename)
    file.each do |line|
      line = line.delete "/?/</-/(/!’"
      line = line.delete '"'
      line = line.delete ")+-"
      line = line.split
      j = 0
      while j < line.size
        collection.push( [line[j].to_s+ '*' +line[j+1].to_s,i])
        j+=1
      end
    end
    i+=1
  end
  return collection
end

def boolean_search_two_word(word, matrix)

  words = word.split " "
  answer = []
  i = 0
  f = true
  while i < $num_of_doc
    answer.push(1);
    i+=1
  end
  j=0
  while j < words.size-1
    word = words[j].to_s+'*'+ words[j+1].to_s
    i = 0

    while i < matrix.size
      m = matrix[i][0]
      if matrix[i][0] == word
        f=false
        answer = check(answer,matrix[i][1..$num_of_doc])
        break
      else
      k = i
      l = matrix.size
      l = matrix[i][0]
      if i == matrix.size-1 && matrix[i][0] != word
        return "not found"
      end
      end
      i+=1

    end
    j+=1
  end
  k=0
  doc = []
  if f
    return "not found"
  end
  while k < $num_of_doc
    if answer[k] == 1
      doc.push(k+1)
    end
    k+=1
  end
  return doc

end

def collection_to_coord()

  collection = []
  i = 1
  while i <= $num_of_doc
    filename ="file_"+i.to_s+".txt"
    file = File.new(filename)
    file.each do |line|
      line = line.delete "/?/</-/(/!’"
      line = line.delete '"'
      line = line.delete ")+-"
      line = line.split
      j = 0
      k = 1
      while j < line.size
        collection.push( [line[j],i,k+=1])
        j+=1
      end
    end
    i+=1
  end
  return collection
end
#test

#myCol = collection_to_a
myCol = collection_to_two_word
get_wordbook_txt("wordbook", myCol)
indx =  create_index(myCol.uniq)
i = 0
puts "inverted index"
while i < indx.size
  print indx[i]
  puts
    i +=1
end
puts "matrix incidence term -> document"
i = 0
matrix = create_matrix(indx)
while i < matrix.size
  print matrix[i]
  puts
  i +=1
end

puts "boolean_search, ID doc"
print boolean_search_two_word("У кінці коридору ліворуч були сходи", matrix)

myCol =  collection_to_coord()
get_wordbook_txt("wordbook2", myCol)
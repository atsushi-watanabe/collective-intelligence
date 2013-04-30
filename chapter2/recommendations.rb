# A dictionary of movie critics and their ratings of a small
# set of movies
$critics={'Lisa Rose'=> {'Lady in the Water'=> 2.5, 'Snakes on a Plane'=> 3.5,
 'Just My Luck'=> 3.0, 'Superman Returns'=> 3.5, 'You, Me and Dupree'=> 2.5, 
 'The Night Listener'=> 3.0},
'Gene Seymour'=> {'Lady in the Water'=> 3.0, 'Snakes on a Plane'=> 3.5, 
 'Just My Luck'=> 1.5, 'Superman Returns'=> 5.0, 'The Night Listener'=> 3.0, 
 'You, Me and Dupree'=> 3.5}, 
'Michael Phillips'=> {'Lady in the Water'=> 2.5, 'Snakes on a Plane'=> 3.0,
 'Superman Returns'=> 3.5, 'The Night Listener'=> 4.0},
'Claudia Puig'=> {'Snakes on a Plane'=> 3.5, 'Just My Luck'=> 3.0,
 'The Night Listener'=> 4.5, 'Superman Returns'=> 4.0, 
 'You, Me and Dupree'=> 2.5},
'Mick LaSalle'=> {'Lady in the Water'=> 3.0, 'Snakes on a Plane'=> 4.0, 
 'Just My Luck'=> 2.0, 'Superman Returns'=> 3.0, 'The Night Listener'=> 3.0,
 'You, Me and Dupree'=> 2.0}, 
'Jack Matthews'=> {'Lady in the Water'=> 3.0, 'Snakes on a Plane'=> 4.0,
 'The Night Listener'=> 3.0, 'Superman Returns'=> 5.0, 'You, Me and Dupree'=> 3.5},
'Toby'=> {'Snakes on a Plane'=>4.5,'You, Me and Dupree'=>1.0,'Superman Returns'=>4.0}}

def sim_distance(prefs,person1,person2)
  # Get the list of shared_items
  si = prefs[person1].keys & prefs[person2].keys

  return 0.0 if si.empty?

  sum_of_squares = si.inject(0.0) {|acc, item|
    acc += (prefs[person1][item] - prefs[person2][item])**2 }

  return 1/(1+sum_of_squares)
end

def sim_pearson(prefs,p1,p2)
  # Get the list of mutually rated items
  si = prefs[p1].keys & prefs[p2].keys

  return 0.0 if si.empty?
  n = si.length
  # Sums of all the preferences
  sum1 = si.inject(0.0) { |acc, item| acc += prefs[p1][item] }
  sum2 = si.inject(0.0) { |acc, item| acc += prefs[p2][item] }
  
  # Sums of the squares
  sum1Sq = si.inject(0.0) { |acc, item| acc += prefs[p1][item]**2 }
  sum2Sq = si.inject(0.0) { |acc, item| acc += prefs[p2][item]**2 }
  
  # Sum of the products
  pSum = si.inject(0.0) { |acc, item|
    acc += prefs[p1][item] * prefs[p2][item] }
  
  # Calculate r (Pearson score)
  num = pSum - (sum1 * sum2 / n)
  den = Math.sqrt((sum1Sq - sum1 ** 2 / n) * (sum2Sq - sum2 ** 2 / n))
  return 0 if den == 0.0 

  r=num/den

  return r
end

def top_matches(prefs, person, n=5)
  scores = (prefs.keys - [person]).map { |other|
    [sim_pearson(prefs, person, other), other] }
  scores.sort!
  scores.reverse!
  return scores[0, n]
end

def get_recommendations(prefs,person):
  totals={}
  simSums={}
  for other in prefs:
    # don't compare me to myself
    if other==person: continue
    sim = sim_pearson(prefs,person,other)

    # ignore scores of zero or lower
    if sim<=0: continue
    for item in prefs[other]:
	    
      # only score movies I haven't seen yet
      if item not in prefs[person] or prefs[person][item]==0:
        # Similarity * Score
        totals.setdefault(item,0)
        totals[item]+=prefs[other][item]*sim
        # Sum of similarities
        simSums.setdefault(item,0)
        simSums[item]+=sim

  # Create the normalized list
  rankings=[(total/simSums[item],item) for item,total in totals.items()]

  # Return the sorted list
  rankings.sort()
  rankings.reverse()
  return rankings
p top_matches($critics, 'Toby')

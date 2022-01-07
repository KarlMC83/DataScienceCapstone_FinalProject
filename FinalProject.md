---
title: "Final Project - Data Science Capstone"
author: "Karl Melgarejo Castillo"
date: "January 6, 2022"
output: 
  html_document:
    keep_md: true
---

## Executive summary

In this document I briefly describe the methodology that I used to build a basic *'next word' prediction algorithm* for any given text. 

This report is part of the Capstone Project of the Johns Hopkins Data Science Specialization which also requires to build a web application. The app can be accessed here <https://karlmc83.shinyapps.io/CapstoneProject/>.

The codes in R that I created to build the algorithm can be accessed from my GitHub repository <https://github.com/KarlMC83/DataScienceCapstone_FinalProject>. 

## 1. Pre-processing data

This was the most exhausting part of the analysis due to the limited memory capacity of my laptop (8 GB of RAM). In a previous analysis, I selected randomly a sample of lines from the three databases (which are very large) by using a binomial process to analyse the main features in an efficient manner. The report can be accessed here <https://github.com/KarlMC83/DataScienceCapstone_MilestoneReport> (there was a mistake in the size of the second database that has been corrected for this final report). 

For this final project, I needed to evaluate a much larger sample in order to improve the accuracy of the prediction. For this task, I proceeded as follows: 1. I joined the three files (from Twitter, News, and Blogs) into one file; 2. I split this new file into 10 parts; 3. I created a *corpus* file with each part and *tokenized* each *corpus* in 2, 3, and 4-gram files, which were saved in my laptop; 4. I created frequency tables with groups of 2 or 3 *tokenized* files (depending on the size) until using all the 10 files to build one frequency table for each *n-gram* model (3 tables in total); 5. Finally, I dropped the words that appeared only once to reduce the dimension of the tables. These tables are shown below: 



**Table of frequencies: 4-gram analysis** (6 most frequent)

```
##                       feature freq
## 2086822        the end of the 7706
## 2165347       the rest of the 6698
## 326737          at the end of 6637
## 1999001 thanks for the follow 6252
## 729869     for the first time 6147
## 329676       at the same time 5093
```

```
## [1] "Number of rows: 2754480"
```

**Table of frequencies: 3-gram analysis** (6 most frequent)

```
##                feature  freq
## 2474694     one of the 34513
## 75307         a lot of 29938
## 3159286 thanks for the 23820
## 3572723        to be a 18170
## 1333621    going to be 17438
## 3274473     the end of 14910
```

```
## [1] "Number of rows: 4149617"
```

**Table of frequencies: 2-gram analysis** (6 most frequent)

```
##         feature   freq
## 1977191  of the 430159
## 1409608  in the 410994
## 2922096  to the 213554
## 1078973 for the 200861
## 2012301  on the 196265
## 2903293   to be 161764
```

```
## [1] "Number of rows: 3267789"
```

## 2. A basic *n-gram* prediction algorithm

In this section I explain the main assumptions and characteristics of the prediction algorithm. 

### 2.1 The intuition

The intuition of an *n-gram* model is that the *next word* of a continuous sequence of *n-1* words from a given sample of text can be predicted by assigning a probability to each possible next word. Thus, the most likely word will be the one with the highest probability. As Jurafsky and Martin (2021) suggest, we can use the relative frequency counts to estimate this probability. This consists of counting the number of times we see the *n-1 gram* sentence in a large *corpus*, and count the number of times this is followed by an specific word. 

For instance, if we have the following sentence *"saved by the"* and we want to know the probability that the next word is *"bell"*, we can calculate the following ratio:

\begin{align*}

\frac{Count(\textrm{saved by the bell})}{Count(\textrm{saved by the})}

\end{align*}

This ratio is just an estimation of the conditional probability $P(\textrm{bell}|\textrm{saved by the}) = \frac{P(\textrm{saved by the } \cap \textrm{ bell})}{P(\textrm{saved by the})}$ and answers the following question: *out of the times we saw "saved by the", how many times was it followed by the word "bell"*. 

This is an example of an *n-gram* prediction model, in which the estimation of the conditional probability is relatively simple to compute. Nevertheless, in the presence of a large sentence we will need to estimate the probability of a word given the history of the entire sentence, which could be difficult to compute. The Markov assumption helps us in this matter.    


### 2.2 Markov assumption

Under the Markov assumption, the probability of a word depends only on the previous *n-1* words. Therefore, in an *4-gram* model, the probability of the last word depends on the 3 previous words; and in a *2-gram*, just on the previous word.

Following Jurafsky and Martin (2021), the maximum likelihood estimation of an *n-gram* model will be:

\begin{align*}

P(w_i|w_{i-n+1:i-1}) = \frac{Count(w_{i-n+1:i-1} w_i)}{Count(w_{i-n+1:i-1})}

\end{align*}

where *w* represents a word in the position *i*, and *n* is the number of words of the *n-gram* model. As an example, we are going to predict the next word of the sentence *"it would mean the"* by using a *4-gram* model:


```
##                          4-gram Freq.       3-prev.words Prob. Prediction
## 2686401    would mean the world   200 -_- would mean the 97.09      world
## 2686398 would mean the absolute     2 -_- would mean the  0.97   absolute
## 2686399      would mean the end     2 -_- would mean the  0.97        end
## 2686400     would mean the loss     2 -_- would mean the  0.97       loss
```

In this example, the word *"world"* has the higher probability and therefore is the prediction of the algorithm. In general, the algorithm will start always with a *4-gram* model and if there is no answer (e.g. a zero probability) it will use the next lower *n-gram* model. This method is called **backoff** and basically means using less context to predict.  

## 3. Room for improvement

The most important limitation of the *n-gram* prediction algorithm is the strong dependency on the training database. Thus, if we use a sentence that is not present in the training database the prediction will lose accuracy.

There are different methods to deal with *new context* in a text prediction model (e.g. Neural Networks, Machine Learning, etc.) but I will use a very simple approach that consists of just calculating the correlations of the words predicted by the *n-model* with all the words in the text given, and without using *stop-words*, which don't add important additional information. Given that the calculation of correlations for many words will require high memory capacity, I will use just a random sample of lines of size 5% of the three databases.



I will show an example of how this simple procedure works with the following sentence: *"Guy at my table's wife got up to go to the bathroom and I asked about dessert and he started telling me about his"*.

By using the *n-gram* model we have two possible solutions: *"marital"* and *"financial"* with probabilities 0.0022 and 0.0237 respectively. The word *financial* is the prediction of the *n-gram* model, due to its higher probability; but it seems that it doesn't fit well in the sentence given. In the following table I show the correlation of these two words with the previous words in the entire sentence (excluding stop words) which is calculated by using all the lines from the selected random sample. 

As we can see, the word *marital* has a positive correlation with the word *wife*, which means that both words were used at the same time in some lines from this sample; on the other hand, no correlation was calculated with the rest of words, which means that these words were not used in lines close to the word *marital*. While for the word *financial*, the words *guy* and *asked* were used in different lines so there was no correlation among them and with the rest of the words no correlation was calculated because those words were not used in lines close to the word *financial*.  


| Previous words / Predicted words     |        Marital       |       Financial      | 
| :---                                 |        :----:        |        :----:        | 
| Guy                                  |       NA      |       0      | 
| Table                                |       NA      |       NA      |
| Wife                                 |       0.01      |       NA      |
| Bathroom                             |       NA      |       NA      |
| Asked                                |       NA      |       0      |
| About                                |       NA      |       NA      |
| Dessert                              |       NA      |       NA      |
| Started                              |       NA      |       NA      |
| Telling                              |       NA      |       NA      |
| His                                  |       NA     |       NA     |
| **Sum of correlations**                  |0.01| 0|

According to these results, the word *marital* seems to be more related to the context of the sentence because it has a higher sum of correlations with words in the given sentence, even though the word *financial* has a higher probability in the *n-gram* prediction model. This approach can be improved by using more sources of text databases to increase the number of correlations and their statistical significance.  

## Bibliography

Hvitfeldt, E. and Silge, J. (2021). *Supervised Machine Learning for Text Analysis in R*. <https://smltar.com/> 

Jurafsky, D. and Martin, J. (2021). *Speech and Language Processing: An Introduction to Natural Language Processing, Computational Linguistics, and Speech Recognition*. <https://web.stanford.edu/~jurafsky/slp3/>

Watanabe, K. and Müller, S. (2021). *QUANTEDA Tutorials*. <https://tutorials.quanteda.io/>

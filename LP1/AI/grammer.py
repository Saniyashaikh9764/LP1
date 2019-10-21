import nltk
nltk.download()
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords

print("Enter the paragraph for which you want to so syntactic analysis?")
sentence=input()


print("Performing Sentence Segmentation")
sentences=sentence.split(".")
for i in sentences:
    print(i)


print("Performing word tokenization")
words_list=list()
sentence_word_list=list()
for i in sentences:
    words=word_tokenize(i)
    sentence_word_list.append(words)
    for j in words:
        words_list.append(j)
print(words_list)

print("Performing stop word removal")
stop_words = set(stopwords.words('english'))
filter_words=list()
for i in words_list:
    if i not in stop_words:
        filter_words.append(i)
print(filter_words)

print("Performing POS Tagging")
for i in filter_words:
    print(nltk.pos_tag(i))

groucho_grammar = nltk.CFG.fromstring("""
S -> NP VP
PP -> P NP
NP -> Det N | Det N PP | 'I'
VP -> V NP | VP PP
Det -> 'an' | 'my'
N -> 'elephant' | 'pajamas'
V -> 'shot'
P -> 'in'
""")
##Does not print anything if not accepting the grammer
parser = nltk.ChartParser(groucho_grammar)
for i in sentence_word_list:
    for tree in parser.parse(sent):
        print(tree)

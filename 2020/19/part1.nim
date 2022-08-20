import tables, strscans, strutils, sequtils
import ../common

type
  RuleKind = enum
    letterRule, metaRule, dualMetaRule
  Rule = object
    case kind: RuleKind
    of letterRule:
      letter: char
    of metaRule, dualMetaRule:
      ruleList: seq[int]

var
  rules: Table[int, Rule]

let input = getInput()
var messages: seq[string]
for line in input:
  var
    ruleN: int
    rule, ruleLetter, ruleString1, ruleString2: string

  proc parseRuleString(ruleList: string): seq[int] = ruleList.split.mapIt(it.parseInt)
  if line.scanf("$i: $+", ruleN, rule):
    if rule.scanf("\"$+\"", ruleLetter):
      rules[ruleN] = Rule(kind: letterRule, letter: ruleLetter[0])
    elif rule.scanf("$+ | $+", ruleString1, ruleString2):
      rules[ruleN] = Rule(
        kind: dualMetaRule, ruleList:
        concat(ruleString1.parseRuleString, @[-1], ruleString2.parseRuleString)
      )
    else:
      rules[ruleN] = Rule(kind: metaRule, ruleList: rule.parseRuleString)
  else:
    if line.strip != "":
      messages.add(line)

proc parseRuleRecursively(rules: Table[int, Rule], ruleN: int,
                          prevRes = @[""]): seq[string] =
  result = prevRes
  case rules[ruleN].kind
  of letterRule:
    echo "adding ", rules[ruleN].letter, " to ", result[^1]
    result[^1] &= rules[ruleN].letter
  of metaRule:
    for ruleN in rules[ruleN].ruleList:
      echo "changing ", result[^1]
      result = parseRuleRecursively(rules, ruleN, result)
      echo "to ", result[^1]
  of dualMetaRule:
    for ruleN in rules[ruleN].ruleList:
      if ruleN != -1:
        echo "changing ", result[^1]
        result = parseRuleRecursively(rules, ruleN, result)
        echo "to ", result[^1]
      else:
        echo "adding new rule"
        result.add(result[^1])

let parsedRule0 = parseRuleRecursively(rules, 0)
echo parsedRule0

var matchingMessages: int
for message in messages:
  if message in parsedRule0:
    matchingMessages += 1

echo matchingMessages

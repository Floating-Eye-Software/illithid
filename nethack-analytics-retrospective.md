# NetHack Analytics

## Retrospective reconstruction of an IRC project idea

**Original remark:** 24 November 2020, `#tnnt`, Hardfought IRC  
**Nickname:** `spleen`  
**Status of this document:** Evidence-based reconstruction incorporating the surviving IRC exchange and the author's later recollection; not a recovered original specification

## Executive summary

“NetHack analytics” was probably conceived as a data-science project using public NetHack server records to describe how people actually play NetHack. The immediate prompt was a joke about the “average” player’s annual ascensions and the distorting effect of an extreme high-volume player. You responded by asking for the standard deviation, then announced the project and connected it explicitly to your data-science bootcamp. Another participant immediately identified the `xlogfile` as an available dataset and invited you to analyze it.

Your later recollection adds an important second context: at approximately the same time, you were thinking about a universal bones-file translator. Such a translator would need a common representation of objects, monsters, terrain, and other entities across variants such as SLASH'EM, dNetHack, EvilHack, and their relatives. A variant-specific magical staff might have to become a generic or mundane staff in a target variant that lacked the original object, with the loss of meaning recorded explicitly.

The most defensible reconstruction is therefore:

> Normalize game entities across NetHack variants into meaningful equivalence classes, then use server records to calculate comparable population, player, object, and play-style statistics.

The surviving IRC remarks prove only the `xlogfile`-analysis component. The cross-variant component comes from the author's later recollection and may have been part of the same idea, a neighbouring idea, or an unrealized connection between the two. Nevertheless, the conceptual fit is strong: the bones translator supplies a common semantic model, while analytics supplies a use for that model beyond file conversion. A modern revival could become the statistical foundation beneath Illithid’s player pages and floating-eye dossiers.

## What the transcript establishes

The relevant conversation began with a joke comparing a prolific player, Luxidream, to “Spiders Georg,” the statistical outlier in a familiar internet joke. Participants then distinguished the mean from the median number of ascensions. You asked, “but what is the standard deviation?” and immediately said you had thought of a new project called “nethack analytics,” adding that you could apply your data-science bootcamp training.

The response from the channel was technically concrete: the data was in the `xlogfile`, and you were encouraged to analyze it. You said you thought you would. The discussion then veered into jokes about advertising and *The Hitchhiker’s Guide to the Galaxy*. There is no further design discussion in that day’s transcript.

Searches for the distinctive phrases “nethack analytics,” “data science,” and “standard deviation” lead only to this exchange in the available TNNT archive. This means the logs support the project’s origin and data source, but not a more detailed feature list.

## The likely research question

The initiating question was not “Who has the highest score?” It was closer to two linked questions:

> What does the distribution of NetHack play look like, and how misleading are simple averages when player activity and success are extremely uneven?

> How can games from different variants be compared when nominally similar objects and mechanics do not share the same identities or exact behaviour?

That framing points toward descriptive and exploratory statistics:

- games and ascensions per player;
- mean, median, standard deviation, percentiles, and distribution shape;
- the influence of prolific outliers on aggregate results;
- ascension rates by player and by character combination;
- turns and real time per game or ascension;
- deaths by cause, dungeon level, and stage of progress;
- role, race, gender, and alignment choices;
- conducts and major achievements;
- changes across tournament days, years, or player cohorts.
- outcomes and behaviour grouped by canonical object classes or capabilities rather than exact variant-specific object names;
- similarities and differences in the object “ecology” of different variants.

The phrase “analytics,” rather than “scoreboard,” suggests discovering patterns and explaining them, not merely ranking players.

## The missing bridge: a cross-variant semantic model

A universal bones-file translator cannot rely on numeric object identifiers or names. Those are meaningful only within a particular game version or variant. It needs an intermediate representation that separates at least four things:

1. **Source identity:** the exact entity in the originating variant and version.
2. **Canonical class:** a broad family such as staff, wand, sword, food, armour, potion, monster, trap, or terrain feature.
3. **Semantic traits:** magical or mundane, material, handedness, offensive or defensive function, granted properties, charges, danger, rarity, and other behaviourally meaningful features.
4. **Target mapping:** an exact equivalent where one exists, otherwise the closest permitted substitute, together with a record of what was changed or lost.

Under this model, a magical staff that does not exist in a target variant should not simply be relabelled and forgotten. The universal record could retain its source identity and magical traits, classify it canonically as a staff, map it to a mundane staff for the target game, and mark the translation as lossy. This is important for both faithful conversion and honest analysis.

The common model would make cross-variant questions possible. Instead of comparing one named shield with another, analytics could compare access to reflection. Instead of comparing exact healing items, it could compare healing resources. Instead of treating every staff as equivalent, it could slice results by the hierarchy `object → tool/weapon → staff → magical staff`, or by capability tags shared across otherwise unrelated objects.

This suggests that the universal bones work and NetHack Analytics may have been two sides of the same deeper project:

- **translation required an ontology** of NetHack entities and equivalences;
- **analytics could reuse that ontology** to aggregate unlike records into comparable categories;
- **analytics could test the ontology** by exposing mappings that produced implausible or misleading comparisons.

## What object-oriented analytics could measure

If sufficiently detailed data were available, useful slices could include:

- survival or ascension outcomes after acquiring reflection, magic resistance, levitation, healing, ranged offence, or escape resources;
- deaths associated with broad hazard, monster, weapon, projectile, or consumable classes;
- object-class abundance and rarity by variant, dungeon region, and depth;
- differences in how variants provide the same functional capability;
- final-inventory composition by outcome, role, or player;
- which source objects translate exactly, approximately, generically, or not at all;
- how much information is lost when bones cross a version or variant boundary;
- whether particular classes of translated bones materially change later games.

These metrics could be hierarchical. A user could begin with all weapons, descend into polearms or staffs, and then examine exact objects within one variant. The same mechanism could group mechanically different objects by function—for example, every source of reflection—when that comparison was more informative than object class.

There is an important data distinction. An `xlogfile` contains one summary record for each completed game but generally does not contain the player's inventory history or every object interaction. A bones file is a rich snapshot of a level at death, but it is a selected and unusual snapshot rather than a complete gameplay trace. Object-level gameplay analytics would therefore need to combine sources:

- `xlogfile` for outcomes, identities, timing, conducts, and achievements;
- dumplogs or end-of-game inventories for terminal player state;
- bones files for preserved death-level state and cross-variant translation research;
- new event telemetry, or possibly ttyrec-derived data, for acquisitions, uses, losses, encounters, and state changes during play.

The universal ontology can unify all of these sources even when the records themselves remain separate.

## Why `xlogfile` was the obvious dataset

NetHack’s extended log records one row per finished game as field/value pairs. Typical fields include score, maximum dungeon level, hit points, death date and cause, character role/race/gender/alignment, turns, real time, start/end timestamps, conducts, achievements, and whether the game ascended. TNNT extends NetHack largely by adding tournament telemetry and challenges without altering ordinary play, making its records especially suitable for this type of work.

The `xlogfile` dataset would support several useful analytical layers:

1. **Population layer:** How many players, games, and ascensions are represented, and how are they distributed?
2. **Player layer:** What are a player’s characteristic roles, outcomes, pace, causes of death, and unusual accomplishments?
3. **Comparative layer:** How do roles, races, strategies, cohorts, servers, variants, or tournament years differ?
4. **Longitudinal layer:** Does a player become faster, more successful, or more adventurous over time?
5. **Semantic layer:** When richer records are joined, how do outcomes relate to canonical object classes and capabilities across variants?

## A plausible 2020 minimum viable project

A realistic bootcamp-scale first project would have been:

1. Download one or more public `xlogfile` datasets.
2. Parse the tab-delimited field/value records into a dataframe.
3. Normalize players, timestamps, character combinations, deaths, conduct flags, and achievement flags.
4. Produce a descriptive report on the distribution of games and ascensions per player.
5. Show how the mean changes when the most prolific player or players are excluded.
6. Add charts for deaths, roles, ascension rates, turns, and real time.
7. Publish the work as a notebook, blog post, or lightweight interactive dashboard.

A second phase could then introduce the universal entity model, import object information from bones or dumplogs, and compare a small number of carefully chosen variants. Attempting every entity from every variant at once would have turned a bootcamp analytics project into a large knowledge-representation and compatibility-engineering programme.

The opening analysis might have been titled something like **“The Average NetHack Player Ascends Zero Times”**. That would preserve the joke while turning it into a serious examination of skewed distributions.

## Important limitations

The project would need to avoid treating server logs as a census of all NetHack players.

- Public-server players are a selected subset of the whole community.
- One nickname may not always equal one person, and one person may use several nicknames or servers.
- Per-game records heavily weight prolific players unless analysis is also performed per player.
- Scummed, abandoned, practice, and tournament games may require separate treatment.
- Completed-game records reveal outcomes and summary properties, not the full sequence of decisions inside a game.
- Bones files overrepresent deaths that were eligible to leave bones and describe the preserved level, not the whole run.
- Variant and version differences can make comparisons misleading.
- Functional equivalence is contextual: two objects may share a class but differ greatly in power, rarity, timing, or side effects.
- A lowest-common-denominator mapping can erase the very differences the analysis is meant to study; source identity and translation loss must therefore be preserved.
- Very small cohorts can make ostensibly anonymous player behaviour recognizable.

These are not reasons to avoid the project; they are part of what would make it a good data-science exercise.

## Relationship to the current Illithid concept

The 2020 idea and the current floating-eye dossier concept are closely related but not identical.

The reconstructed 2020 project begins with **game-summary records** and may extend through a **cross-variant entity ontology** into object-level comparisons. The floating-eye proposal begins with **new, encounter-level observations** and constructs a player-facing narrative dossier: what floating eyes have collectively observed a particular player doing or wearing.

They can now be understood as two layers of one system:

- **NetHack Analytics:** factual statistical summaries derived from completed games and server events.
- **Universal NetHack ontology:** canonical classes, capabilities, equivalence mappings, provenance, and explicit translation loss across variants.
- **Floating-eye dossier:** a deliberately fictionalized, in-world presentation of selected player telemetry.

Illithid’s future interactive website could expose both. A player page might contain conventional personal records and high scores, population comparisons, and a separate floating-eye dossier. The analytics layer would supply trustworthy calculations; the dossier layer would give a subset of the data personality and thematic meaning.

The present project boundaries suggest a clean implementation split:

- **Bonegraft** owns bones parsing, the canonical entity schema, variant/version adapters, equivalence rules, and translation-loss reporting.
- **Illithid/NetHack telemetry** records gameplay facts using stable canonical identifiers or traits where appropriate.
- **NetHack Analytics** joins game outcomes, snapshots, and events and performs the statistical analysis.
- **The Illithid website** presents personal records, population comparisons, and the floating-eye dossier.

The universal representation should be richer than the least capable target. A magical staff should remain identifiable as the original magical staff in canonical storage even if export to another variant produces only a mundane staff. Otherwise translation would permanently destroy distinctions that analytics needs.

This does not prove that you anticipated the dossier in 2020. It shows that the old idea is a strong conceptual ancestor of the current plan.

## Recommended interpretation

The best concise reconstruction is:

> NetHack Analytics was an idea for applying data-science methods to public game records, beginning with the highly skewed distribution of ascensions among players and plausibly extending to cross-variant analysis through the same canonical entity and equivalence model needed by a universal bones-file translator.

The surviving conversation contains an origin story and one dataset, not a lost specification. The cross-variant reconstruction is strengthened by the author's recollection and by its technical coherence with the contemporaneous universal bones work, but it remains a reconstruction. Any implementation today should therefore be described as a revival and development of the 2020 idea, rather than a literal completion of a fully defined earlier plan.

## Sources

- [Hardfought TNNT IRC log, 24 November 2020](https://www.hardfought.org/nh/browseirc_tnnt_db.php?date=2020-11-24)
- [Direct Hardfought search result for “nethack analytics”](https://www.hardfought.org/nh/browseirc_tnnt_db.php?date=2020-11-24&search=nethack+analytics&global_search=nethack+analytics&searchpage=1&viewing_result=1)
- [NetHackWiki: xlogfile format and fields](https://nethackwiki.com/wiki/Xlogfile)
- [TNNT source repository](https://github.com/tnnt-devteam/tnnt)
- [NetHack Scoreboard: description of consolidated public-server statistics](https://nethackscoreboard.org/about.html)

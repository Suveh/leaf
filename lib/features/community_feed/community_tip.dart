/// A single community tip post. Dummy/read-only data — there is no posting
/// or backend yet.
class CommunityTip {
  const CommunityTip({
    required this.userName,
    required this.tipText,
    required this.likeCount,
  });

  final String userName;
  final String tipText;
  final int likeCount;
}

const dummyCommunityTips = <CommunityTip>[
  CommunityTip(
    userName: 'Jordan P.',
    tipText:
        "Bottom-water your African violets — getting water on the leaves "
        "causes ugly brown spots.",
    likeCount: 42,
  ),
  CommunityTip(
    userName: 'Ade K.',
    tipText:
        'Rotate your plants a quarter turn every time you water so they '
        'grow evenly instead of leaning toward the window.',
    likeCount: 31,
  ),
  CommunityTip(
    userName: 'Maria S.',
    tipText:
        "Yellow leaves on a pothos usually mean overwatering, not "
        "underwatering. Check the soil before reaching for the can.",
    likeCount: 58,
  ),
  CommunityTip(
    userName: 'Tom R.',
    tipText:
        'A cheap moisture meter is worth it if you tend to forget which '
        'plants you watered last.',
    likeCount: 19,
  ),
  CommunityTip(
    userName: 'Priya N.',
    tipText:
        "Group humidity-loving plants together — they create a little "
        "microclimate for each other.",
    likeCount: 27,
  ),
  CommunityTip(
    userName: 'Chidi O.',
    tipText:
        'Wipe dust off broad leaves like monstera and fiddle leaf fig so '
        'they can actually photosynthesize efficiently.',
    likeCount: 63,
  ),
  CommunityTip(
    userName: 'Lena F.',
    tipText:
        "Repot in spring when the plant is actively growing, not in "
        "winter when it's dormant.",
    likeCount: 22,
  ),
];

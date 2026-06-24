const parserOpts = {
  headerPattern: /^(\w+)(?:[(/]([^)!:]+)\)?)?(!)?: (.+)$/,
  headerCorrespondence: ["type", "scope", "breaking", "subject"],
  breakingHeaderPattern: /^(\w+)(?:[(/]([^)!:]+)\)?)?!: (.+)$/,
  noteKeywords: ["BREAKING CHANGE", "BREAKING CHANGES", "BREAKING"],
};

const releaseRules = [
  { breaking: true, release: "major" },
  { type: "feat", release: "minor" },
  { type: "fix", release: "patch" },
  { type: "perf", release: "patch" },
  { type: "refactor", release: "patch" },
  { type: "docs", release: "patch" },
  { type: "build", release: "patch" },
  { type: "ci", release: "patch" },
  { type: "test", release: "patch" },
  { type: "style", release: "patch" },
  { type: "chore", release: "patch" },
  { type: "revert", release: "patch" },
];

const types = [
  { type: "feat", section: "New Features", hidden: false },
  { type: "fix", section: "Fixese", hidden: false },
  { type: "perf", section: "Performance Improvements", hidden: false },
  { type: "refactor", section: "Refactoring", hidden: false },
  { type: "docs", section: "Documentation", hidden: false },
  { type: "build", section: "Build System", hidden: false },
  { type: "ci", section: "CI", hidden: false },
  { type: "test", section: "Tests", hidden: false },
  { type: "style", section: "Style", hidden: false },
  { type: "chore", section: "Chores", hidden: false },
  { type: "revert", section: "Reverts", hidden: false },
];

module.exports = {
  branches: ["main"],
  tagFormat: "v${version}",
  plugins: [
    [
      "@semantic-release/commit-analyzer",
      {
        preset: "conventionalcommits",
        parserOpts,
        releaseRules,
      },
    ],
    [
      "@semantic-release/release-notes-generator",
      {
        preset: "conventionalcommits",
        parserOpts,
        presetConfig: {
          types,
        },
      },
    ],
    [
      "@semantic-release/changelog",
      {
        changelogFile: "CHANGELOG.md",
      },
    ],
    [
      "@semantic-release/git",
      {
        assets: ["CHANGELOG.md"],
        message: "chore(release): ${nextRelease.gitTag} [skip ci]\n\n${nextRelease.notes}",
      },
    ],
    [
      "@semantic-release/github",
      {
        successComment: false,
        failComment: false,
      },
    ],
  ],
};

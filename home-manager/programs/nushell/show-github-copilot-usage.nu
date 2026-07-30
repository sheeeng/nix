# Display GitHub Copilot premium request usage. The endpoint is
# undocumented and may change.
def show-github-copilot-usage [--color] {
  let copilot_usage = (^gh api /copilot_internal/user | from json)
  let premium_usage = $copilot_usage.quota_snapshots.premium_interactions
  let usage_meter_width = 20
  let allowance_percentage_value = $premium_usage.quota_remaining / $premium_usage.entitlement * 100
  let remaining_meter_cell_count = (
    $allowance_percentage_value * $usage_meter_width / 100
    | math round
    | into int
  )
  let consumed_meter_cell_count = $usage_meter_width - $remaining_meter_cell_count
  let remaining_meter = (
    "" | fill --character ">" --width $remaining_meter_cell_count
  )
  let consumed_meter = (
    "" | fill --character "-" --width $consumed_meter_cell_count
  )
  let allowance_percentage = $allowance_percentage_value | into string --decimals 1
  let remaining_allowance_parts = $premium_usage.quota_remaining | into string --decimals 1 | split row "."
  let remaining_allowance = $"($remaining_allowance_parts.0 | into int | into string --group-digits).($remaining_allowance_parts.1)"
  let total_allowance = $premium_usage.entitlement | into string --group-digits
  let used_ai_credits = $premium_usage.credits_used | into string --group-digits
  let used_ai_credit_cost_usd = (
    $premium_usage.credits_used * 0.01
    | into string --decimals 2
  )
  let copilot_plan = $copilot_usage.copilot_plan | str capitalize
  let usage_meter = $"[($remaining_meter)($consumed_meter)]"
  let displayed_usage_meter = if $color {
    let meter_color = match $allowance_percentage_value {
      $remaining_quota if $remaining_quota <= 25 => (ansi red)
      $remaining_quota if $remaining_quota <= 50 => (ansi yellow)
      $remaining_quota if $remaining_quota <= 75 => (ansi cyan)
      _ => (ansi green)
    }

    $"($meter_color)($usage_meter)(ansi reset)"
  } else {
    $usage_meter
  }

  [
    $"GitHub · Copilot ($copilot_plan) · Usage"
    $"Allowance: [($remaining_allowance)/($total_allowance)] ($allowance_percentage)% ($displayed_usage_meter)"
    $"Credits Used: ($used_ai_credits) ≈ $($used_ai_credit_cost_usd)"
  ] | str join (char newline)
}

def show-github-copilot-usage-compact [] {
  let copilot_usage = (^gh api /copilot_internal/user | from json)
  let premium_usage = $copilot_usage.quota_snapshots.premium_interactions
  let usage_meter_width = 20
  let allowance_percentage_value = $premium_usage.quota_remaining / $premium_usage.entitlement * 100
  let remaining_meter_cell_count = (
    $allowance_percentage_value * $usage_meter_width / 100
    | math round
    | into int
  )
  let consumed_meter_cell_count = $usage_meter_width - $remaining_meter_cell_count
  let remaining_meter = (
    "" | fill --character ">" --width $remaining_meter_cell_count
  )
  let consumed_meter = (
    "" | fill --character "-" --width $consumed_meter_cell_count
  )
  let allowance_percentage = $allowance_percentage_value | into string --decimals 1
  let used_ai_credits = $premium_usage.credits_used | into string --group-digits
  let used_ai_credit_cost_usd = (
    $premium_usage.credits_used * 0.01
    | into string --decimals 2
  )
  let copilot_plan = $copilot_usage.copilot_plan | str capitalize
  let usage_meter = $"[($remaining_meter)($consumed_meter)]"

  [
    $"Copilot ($copilot_plan)"
    $"Allowance: ($allowance_percentage)% ($usage_meter)"
    $"Credits Used: ($used_ai_credits) ≈ $($used_ai_credit_cost_usd)"
  ] | str join (char newline)
}

def show-github-copilot-usage-detailed [] {
  let copilot_usage = (^gh api /copilot_internal/user | from json)
  let premium_usage = $copilot_usage.quota_snapshots.premium_interactions
  let usage_meter_width = 20
  let allowance_percentage_value = $premium_usage.quota_remaining / $premium_usage.entitlement * 100
  let remaining_meter_cell_count = (
    $allowance_percentage_value * $usage_meter_width / 100
    | math round
    | into int
  )
  let consumed_meter_cell_count = $usage_meter_width - $remaining_meter_cell_count
  let remaining_meter = (
    "" | fill --character ">" --width $remaining_meter_cell_count
  )
  let consumed_meter = (
    "" | fill --character "-" --width $consumed_meter_cell_count
  )
  let allowance_percentage = $allowance_percentage_value | into string --decimals 1
  let remaining_allowance_parts = $premium_usage.quota_remaining | into string --decimals 1 | split row "."
  let remaining_allowance = $"($remaining_allowance_parts.0 | into int | into string --group-digits).($remaining_allowance_parts.1)"
  let total_allowance = $premium_usage.entitlement | into string --group-digits
  let used_ai_credits = $premium_usage.credits_used | into string --group-digits
  let used_ai_credit_cost_usd = (
    $premium_usage.credits_used * 0.01
    | into string --decimals 2
  )
  let copilot_plan = $copilot_usage.copilot_plan | str capitalize
  let usage_meter = $"[($remaining_meter)($consumed_meter)]"

  [
    $"GitHub · Copilot ($copilot_plan) · Usage"
    $"Remaining Allowance: ($remaining_allowance) of ($total_allowance)"
    $"Allowance Remaining: ($allowance_percentage)% ($usage_meter)"
    $"Credits Used: ($used_ai_credits)"
    $"Equivalent Value: $($used_ai_credit_cost_usd)"
  ] | str join (char newline)
}

def show-github-copilot-usage-counters [] {
  let copilot_usage = (^gh api /copilot_internal/user | from json)
  let premium_usage = $copilot_usage.quota_snapshots.premium_interactions
  let allowance_percentage_value = $premium_usage.quota_remaining / $premium_usage.entitlement * 100
  let consumed_allowance_value = $premium_usage.entitlement - $premium_usage.quota_remaining
  let allowance_percentage = $allowance_percentage_value | into string --decimals 1
  let remaining_allowance_parts = $premium_usage.quota_remaining | into string --decimals 1 | split row "."
  let remaining_allowance = $"($remaining_allowance_parts.0 | into int | into string --group-digits).($remaining_allowance_parts.1)"
  let consumed_allowance_parts = $consumed_allowance_value | into string --decimals 1 | split row "."
  let consumed_allowance = $"($consumed_allowance_parts.0 | into int | into string --group-digits).($consumed_allowance_parts.1)"
  let total_allowance = $premium_usage.entitlement | into string --group-digits
  let used_ai_credits = $premium_usage.credits_used | into string --group-digits
  let used_ai_credit_cost_usd = (
    $premium_usage.credits_used * 0.01
    | into string --decimals 2
  )
  let copilot_plan = $copilot_usage.copilot_plan | str capitalize

  [
    $"GitHub · Copilot ($copilot_plan) · Usage"
    $"Quota Remaining: ($allowance_percentage)% [($remaining_allowance)/($total_allowance)]"
    $"Quota Consumed: ($consumed_allowance)"
    $"Credits Used: ($used_ai_credits) ≈ $($used_ai_credit_cost_usd)"
  ] | str join (char newline)
}

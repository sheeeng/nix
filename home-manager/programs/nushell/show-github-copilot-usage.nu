# Display GitHub Copilot premium request usage. The endpoint is
# undocumented and may change.
def show-github-copilot-usage [--color] {
  let copilot_usage = (^gh api /copilot_internal/user | from json)
  let premium_usage = $copilot_usage.quota_snapshots.premium_interactions
  let usage_meter_width = 20
  let remaining_meter_cell_count = (
    $premium_usage.percent_remaining * $usage_meter_width / 100
    | math round
    | into int
  )
  let used_meter_cell_count = $usage_meter_width - $remaining_meter_cell_count
  let remaining_meter = (
    "" | fill --character "█" --width $remaining_meter_cell_count
  )
  let used_meter = (
    "" | fill --character "░" --width $used_meter_cell_count
  )
  let quota_reset_time = (
    $copilot_usage.quota_reset_date_utc?
    | default $copilot_usage.quota_reset_date?
    | default "unknown"
  )
  let used_ai_credit_cost_usd = (
    $premium_usage.credits_used * 0.01
    | into string --decimals 2
  )
  let used_ai_credits = $premium_usage.credits_used | into string --group-digits
  let usage_meter = $"[($remaining_meter)($used_meter)]"
  let displayed_usage_meter = if $color {
    let meter_color = match $premium_usage.percent_remaining {
      $remaining_quota if $remaining_quota <= 25 => (ansi red)
      $remaining_quota if $remaining_quota <= 50 => (ansi yellow)
      $remaining_quota if $remaining_quota <= 75 => (ansi cyan)
      _ => (ansi green)
    }

    $"($meter_color)($usage_meter)(ansi reset)"
  } else {
    $usage_meter
  }

  $"GitHub Copilot ($displayed_usage_meter) ($premium_usage.percent_remaining)% remaining · ($premium_usage.remaining)/($premium_usage.entitlement) premium requests · Reported usage ($used_ai_credits) AI credits, equivalent to $($used_ai_credit_cost_usd) USD. · ($copilot_usage.copilot_plan) · resets ($quota_reset_time)"
}

def show-github-copilot-usage-without-color [] {
  let copilot_usage = (^gh api /copilot_internal/user | from json)
  let premium_usage = $copilot_usage.quota_snapshots.premium_interactions
  let usage_meter_width = 20
  let remaining_meter_cell_count = (
    $premium_usage.percent_remaining * $usage_meter_width / 100
    | math round
    | into int
  )
  let used_meter_cell_count = $usage_meter_width - $remaining_meter_cell_count
  let remaining_meter = (
    "" | fill --character "█" --width $remaining_meter_cell_count
  )
  let used_meter = (
    "" | fill --character "░" --width $used_meter_cell_count
  )
  let quota_reset_time = (
    $copilot_usage.quota_reset_date_utc?
    | default $copilot_usage.quota_reset_date?
    | default "unknown"
  )
  let used_ai_credit_cost_usd = (
    $premium_usage.credits_used * 0.01
    | into string --decimals 2
  )
  let used_ai_credits = $premium_usage.credits_used | into string --group-digits
  let usage_meter = $"[($remaining_meter)($used_meter)]"

  $"GitHub Copilot ($usage_meter) ($premium_usage.percent_remaining)% remaining · ($premium_usage.remaining)/($premium_usage.entitlement) premium requests · Reported usage ($used_ai_credits) AI credits, equivalent to $($used_ai_credit_cost_usd) USD. · ($copilot_usage.copilot_plan) · resets ($quota_reset_time)"
}

def show-github-copilot-usage-with-color [] {
  let copilot_usage = (^gh api /copilot_internal/user | from json)
  let premium_usage = $copilot_usage.quota_snapshots.premium_interactions
  let usage_meter_width = 20
  let remaining_meter_cell_count = (
    $premium_usage.percent_remaining * $usage_meter_width / 100
    | math round
    | into int
  )
  let used_meter_cell_count = $usage_meter_width - $remaining_meter_cell_count
  let remaining_meter = (
    "" | fill --character "█" --width $remaining_meter_cell_count
  )
  let used_meter = (
    "" | fill --character "░" --width $used_meter_cell_count
  )
  let quota_reset_time = (
    $copilot_usage.quota_reset_date_utc?
    | default $copilot_usage.quota_reset_date?
    | default "unknown"
  )
  let used_ai_credit_cost_usd = (
    $premium_usage.credits_used * 0.01
    | into string --decimals 2
  )
  let used_ai_credits = $premium_usage.credits_used | into string --group-digits
  let usage_meter = $"[($remaining_meter)($used_meter)]"
  let meter_color = match $premium_usage.percent_remaining {
    $remaining_quota if $remaining_quota <= 25 => (ansi red)
    $remaining_quota if $remaining_quota <= 50 => (ansi yellow)
    $remaining_quota if $remaining_quota <= 75 => (ansi cyan)
    _ => (ansi green)
  }
  let displayed_usage_meter = $"($meter_color)($usage_meter)(ansi reset)"

  $"GitHub Copilot ($displayed_usage_meter) ($premium_usage.percent_remaining)% remaining · ($premium_usage.remaining)/($premium_usage.entitlement) premium requests · Reported usage ($used_ai_credits) AI credits, equivalent to $($used_ai_credit_cost_usd) USD. · ($copilot_usage.copilot_plan) · resets ($quota_reset_time)"
}

import Foundation

/**
 Easing functions for smooth animations and transitions.
 All functions take a value in range [0, 1] and return an eased value.
 */
public enum Easing {
    // MARK: - Linear

    public static func linear(_ t: Double) -> Double {
        t
    }

    // MARK: - Quadratic

    public static func quadraticIn(_ t: Double) -> Double {
        t * t
    }

    public static func quadraticOut(_ t: Double) -> Double {
        t * (2 - t)
    }

    public static func quadraticInOut(_ t: Double) -> Double {
        t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t
    }

    // MARK: - Cubic

    public static func cubicIn(_ t: Double) -> Double {
        t * t * t
    }

    public static func cubicOut(_ t: Double) -> Double {
        let f = t - 1
        return f * f * f + 1
    }

    public static func cubicInOut(_ t: Double) -> Double {
        t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1
    }

    // MARK: - Quartic

    public static func quarticIn(_ t: Double) -> Double {
        t * t * t * t
    }

    public static func quarticOut(_ t: Double) -> Double {
        let f = t - 1
        return 1 - f * f * f * f
    }

    public static func quarticInOut(_ t: Double) -> Double {
        let f = t - 1
        return t < 0.5 ? 8 * t * t * t * t : 1 - 8 * f * f * f * f
    }

    // MARK: - Quintic

    public static func quinticIn(_ t: Double) -> Double {
        t * t * t * t * t
    }

    public static func quinticOut(_ t: Double) -> Double {
        let f = t - 1
        return f * f * f * f * f + 1
    }

    public static func quinticInOut(_ t: Double) -> Double {
        let f = t - 1
        return t < 0.5 ? 16 * t * t * t * t * t : 1 + 16 * f * f * f * f * f
    }

    // MARK: - Sine

    public static func sineIn(_ t: Double) -> Double {
        1 - cos(t * .pi / 2)
    }

    public static func sineOut(_ t: Double) -> Double {
        sin(t * .pi / 2)
    }

    public static func sineInOut(_ t: Double) -> Double {
        -(cos(.pi * t) - 1) / 2
    }

    // MARK: - Exponential

    public static func exponentialIn(_ t: Double) -> Double {
        t == 0 ? 0 : pow(2, 10 * (t - 1))
    }

    public static func exponentialOut(_ t: Double) -> Double {
        t == 1 ? 1 : 1 - pow(2, -10 * t)
    }

    public static func exponentialInOut(_ t: Double) -> Double {
        if t == 0 { return 0 }
        if t == 1 { return 1 }
        let scaledTime = t * 2
        if scaledTime < 1 {
            return 0.5 * pow(2, 10 * (scaledTime - 1))
        }
        return 0.5 * (2 - pow(2, -10 * (scaledTime - 1)))
    }

    // MARK: - Circular

    public static func circularIn(_ t: Double) -> Double {
        1 - sqrt(1 - t * t)
    }

    public static func circularOut(_ t: Double) -> Double {
        sqrt((2 - t) * t)
    }

    public static func circularInOut(_ t: Double) -> Double {
        if t < 0.5 {
            return 0.5 * (1 - sqrt(1 - 4 * t * t))
        }
        let f = 2 * t - 2
        return 0.5 * (sqrt(1 - f * f) + 1)
    }

    // MARK: - Elastic

    public static func elasticIn(_ t: Double) -> Double {
        if t == 0 { return 0 }
        if t == 1 { return 1 }
        let p = 0.3
        let s = p / 4
        let scaledTime = t - 1
        return -pow(2, 10 * scaledTime) * sin((scaledTime - s) * (2 * .pi) / p)
    }

    public static func elasticOut(_ t: Double) -> Double {
        if t == 0 { return 0 }
        if t == 1 { return 1 }
        let p = 0.3
        let s = p / 4
        return pow(2, -10 * t) * sin((t - s) * (2 * .pi) / p) + 1
    }

    public static func elasticInOut(_ t: Double) -> Double {
        if t == 0 { return 0 }
        if t == 1 { return 1 }
        let p = 0.45
        let s = p / 4
        let scaledTime = t * 2 - 1
        if scaledTime < 0 {
            return -0.5 * pow(2, 10 * scaledTime) * sin((scaledTime - s) * (2 * .pi) / p)
        }
        return 0.5 * pow(2, -10 * scaledTime) * sin((scaledTime - s) * (2 * .pi) / p) + 1
    }

    // MARK: - Back

    public static func backIn(_ t: Double) -> Double {
        let s = 1.70158
        return t * t * ((s + 1) * t - s)
    }

    public static func backOut(_ t: Double) -> Double {
        let s = 1.70158
        let f = t - 1
        return f * f * ((s + 1) * f + s) + 1
    }

    public static func backInOut(_ t: Double) -> Double {
        let s = 1.70158 * 1.525
        let scaledTime = t * 2
        if scaledTime < 1 {
            return 0.5 * scaledTime * scaledTime * ((s + 1) * scaledTime - s)
        }
        let f = scaledTime - 2
        return 0.5 * (f * f * ((s + 1) * f + s) + 2)
    }

    // MARK: - Bounce

    public static func bounceIn(_ t: Double) -> Double {
        1 - bounceOut(1 - t)
    }

    public static func bounceOut(_ t: Double) -> Double {
        if t < 1 / 2.75 {
            return 7.5625 * t * t
        } else if t < 2 / 2.75 {
            let f = t - 1.5 / 2.75
            return 7.5625 * f * f + 0.75
        } else if t < 2.5 / 2.75 {
            let f = t - 2.25 / 2.75
            return 7.5625 * f * f + 0.9375
        } else {
            let f = t - 2.625 / 2.75
            return 7.5625 * f * f + 0.984375
        }
    }

    public static func bounceInOut(_ t: Double) -> Double {
        if t < 0.5 {
            return bounceIn(t * 2) * 0.5
        }
        return bounceOut(t * 2 - 1) * 0.5 + 0.5
    }
}
